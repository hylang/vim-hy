(import vim)

(defn vimfns (object))
(defreader v [name]
  `(do
     (unless (hasattr vimfns ~name)
       (setattr vimfns ~name (vim.Function ~name)))
     (getattr vimfns ~name)))

(defn cursor [line &optional [col 0]]
  (#v"cursor" line col))

(defn searchpairpos [begin end skip]
  (#v"searchpairpos" begin "" end "bW" skip))

(defn syn-id-name []
  (#v"synIDattr" (#v"synID" (#v"line" ".")
                            (#v"col" ".")
                            0)
                 "name"))

(defn current-char []
  (try
    (get (#v"getline" ".") (dec (#v"col" ".")))
    (catch [e IndexError]
      None)))

(defn skip-position []
  (or
    (not-in (or (current-char) "nothing") "[](){}")
    (in (syn-id-name) ["hyString" "hyComment"])))

(defn prev-pair [begin end here]
  (cursor here)
  (searchpairpos begin end "pyeval('hy_indent.skip_position()')"))

(defn first-word [pos]
  (->> (slice (#v"getline" (first pos)) (second pos))
    .split
    (filter (fn [x] (not (empty? x))))
    first
    .strip))

(defn is-last-word [pos]
  "Returns True if pos is inside the last word on a line"
  (let [[l (slice (#v"getline" (first pos)) (second pos))]
        [i (list (filter (fn [x] (not (empty? x))) (.split l)))]]
    (= (len i) 1)))

(defn export-result [varname]
  "Decorator that wraps a function so that its return value is exported as a Vim variable"
  (fn [f]
    (fn [&rest args]
      (let [[r (apply f args)]]
        (vim.command (.format r"let {}='{}'" varname (str r)))
        r))))

(with-decorator (export-result "indent_result")
  (defn do-indent [lnum]
    (setv lnum (int lnum))
    (setv align (-> (filter (fn [(, pos _)]
                              (and (not (= (+ (first pos) (second pos)) 0))
                                (< (first pos) lnum)))
                            [(, (prev-pair "{" "}" lnum) 'braces)
                             (, (prev-pair r"\[" r"\]" lnum) 'brackets)
                             (, (prev-pair "(" ")" lnum) 'parens)])
                  (sorted :reverse True
                          :key (fn [(, pos _)]
                                 (, (- (first pos) lnum)
                                    (second pos))))
                  first))
    (cond
      [(none? align) 0] ; Top level form
      [(= (second align) 'parens) ; Lisp indent
       (let [[w (first-word (first align))]
             [lw (int (vim.eval (.format r"&lispwords =~# '\V\<{}\>'" w)))]]
         (if (or (= lw 1) (last-word? (first align)))
           (dec (+ (second (first align)) (int (vim.eval "&shiftwidth"))))
           (inc (+ (second (first align)) (len w)))))]
      [True
       (second (first align))])))
