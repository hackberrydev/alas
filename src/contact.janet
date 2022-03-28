### ————————————————————————————————————————————————————————————————————————————
### This module implements contact entity and related functions.

(defn build-contact [name &keys {:category category :birthday birthday :last-contact last-contact}]
  {:name name
   :category category
   :birthday birthday
   :last-contact last-contact})
