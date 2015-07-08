(import re)
(import vim)

(defreader v [name]
  `(vim.Function ~name))

(defn cursor [line &optional [col 0]]
  (#v"cursor" line col))


(defn prev-pair [begin end here]
  (cursor here)
  (searchpairpos begin end))

(defn first-word [pos]
  (-> (re.split r"\s+" (slice (#v"getline" (first pos)) (second pos)) 1)
    first
    .strip))

(defn export-result [f]
  (fn [&rest args]
    (let [[r (apply f args)]]
      (vim.command (.format "let indent_result='{}'" (str r))))
    None))

(with-decorator export-result
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
         (if (= lw 1)
           (dec (+ (second (first align)) (int (vim.eval "&shiftwidth"))))
           (inc (+ (second (first align)) (len w)))))]
      [True
       (second (first align))])))
