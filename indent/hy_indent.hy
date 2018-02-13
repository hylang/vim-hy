(import vim)

(defn vimfns (object))
(defsharp v [name]
  `(do
     (unless (hasattr vimfns ~name)
       (setattr vimfns ~name (vim.Function ~name)))
     (getattr vimfns ~name)))

(defn syn-id-attr [id attr]
  (#v"synIDattr" id attr))

(defn syn-id [l c]
  (#v"synID" l c 0))

(defn syn-id-name [line col]
  (syn-id-attr (syn-id line col) "name"))

(defn skip-position [line col]
  (in (syn-id-name (inc line) (inc col)) ["hyString" "hyComment"]))

(defn first-word [pos]
  (->> (cut (#v"getline" (first pos)) (second pos))
    .split
    (filter (fn [x] (not (empty? x))))
    first
    .strip))

(defn is-last-word [pos]
  "Returns True if pos is inside the last word on a line"
  (let [l (cut (#v"getline" (first pos)) (second pos))
        i (list (filter (fn [x] (not (empty? x))) (.split l)))]
    (= (len i) 1)))

(defn paren-pair [bchar echar line col]
  (let [stuff (cut (. vim current buffer) 0 line)
        skip 0
        pos None]
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
      pos)))

(defn do-indent [lnum]
  (setv lnum (int lnum))
  (setv col (#v"col" "."))
  (setv align (-> (filter (fn [(, pos _)]
                            (and (not (= (+ (first pos) (second pos)) 0))
                              (< (first pos) lnum)))
                          [(, (paren-pair "{" "}" lnum col) 'braces)
                           (, (paren-pair "[" "]" lnum col) 'brackets)
                           (, (paren-pair "(" ")" lnum col) 'parens)])
                (sorted :reverse True
                        :key (fn [(, pos _)]
                               (, (- (first pos) lnum)
                                  (second pos))))
                first))
  (cond
    [(none? align) 0] ; Top level form
    [(= (second align) 'parens) ; Lisp indent
     (let [w (first-word (first align))
           lw (in w (.split (get (. vim current buffer options) "lispwords") ","))]
       (if (or lw (last-word? (first align)))
         (dec (+ (second (first align)) (get (. vim current buffer options) "shiftwidth")))
         (inc (+ (second (first align)) (len w)))))]
    [True
     (second (first align))]))
