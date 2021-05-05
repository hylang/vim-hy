(import vim)

(defn vimfns [] (object))
(defmacro "#v" [name]
  `(do
     (unless (hasattr vimfns ~name)
       (setattr vimfns ~name (vim.Function ~name)))
     (getattr vimfns ~name)))

(defn syn-id-attr [id attr]
  (vim.command (.format "synIDattr({0}, {1})" id attr)))

(defn syn-id [l c]
  (vim.command (.format "synID({0}, {1}, 0)" l c)))

(defn syn-id-name [line col]
  (syn-id-attr (syn-id line col) "name"))

(defn skip-position [line col]
  (in (syn-id-name (inc line) (inc col)) ["hyString" "hyComment"]))

(defn first-word [pos]
  (->> (cut (vim.command (.fomrat "getline({0})" (first pos))) (second pos))
    .split
    (filter (fn [x] (not (empty? x))))
    first
    .strip))

(defn is-last-word [pos]
  "Returns True if pos is inside the last word on a line"
  (setv l (cut (vim.command (.fomrat "getline({0})" (first pos))) (second pos)))
  (setv i (list (filter (fn [x] (not (empty? x))) (.split l))))
  (= (len i) 1))

(defn paren-pair [bchar echar line col]
  (setv stuff (cut (. vim current buffer) 0 line))
  (setv skip 0)
  (setv pos None)
  (setv (get stuff -1) (cut (last stuff) 0 col))
  (for [l (reversed (list (enumerate stuff)))
            c (reversed (list (enumerate (get l 1))))]
       (if (and (in (get c 1) [echar bchar]) (skip-position (get l 0) (get c 0)))
         (continue))
       (cond
         [(= (get c 1) echar)
          (setv skip (inc skip))]
         [(= (get c 1) bchar)
          (if (= 0 skip)
            (if (none? pos)
              (setv pos (, (inc (get l 0)) (inc (get c 0)))))
            (setv skip (dec skip)))]))
    (if (none? pos)
      (, 0 0)
      pos))

(defn do-indent [lnum]
  (setv lnum (int lnum))
  (setv col (int (vim.eval "col('.')")))
  (setv align (-> (filter (fn [pos]
                            (and (not (= (first pos) 0))
                                 (< (first pos) lnum)))
                          [(paren-pair "{" "}" lnum col)
                           (paren-pair "[" "]" lnum col)
                           (paren-pair "(" ")" lnum col)])
                (sorted :reverse True
                        :key (fn [pos]
                               (, (- (first pos) lnum)
                                  (second pos))))
                first))
  (cond
    [(none? align) 0] ; Top level form
    [(= (second align) 'parens) ; Lisp indent
     (setv w (first-word (first align)))
     (setv lw (in w (.split (get (. vim current buffer options) "lispwords") ",")))
     (if (or lw (last-word? (first align)))
       (dec (+ (second (first align)) (get (. vim current buffer options) "shiftwidth")))
       (inc (+ (second (first align)) (len w))))]
    [True
     (second (first align))]))
