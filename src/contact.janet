### ————————————————————————————————————————————————————————————————————————————
### This module implements contact entity and related functions.

(defn build-contact [name &keys {:category category :birthday birthday :last-contact last-contact}]
  (def category-val (cond
                     (keyword? category) category
                     (string? category) (keyword (string/ascii-lower category))
                     category))
  {:name name
   :category category-val
   :birthday birthday
   :last-contact last-contact})
