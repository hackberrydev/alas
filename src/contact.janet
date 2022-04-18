### ————————————————————————————————————————————————————————————————————————————––––––––––––––––––––
### This module implements contact entity and related functions.

(import ./date :as d)

(def next-contact-periods # in days
  {:a 20
   :b 60
   :c 180
   :d 360})

## ————————————————————————————————————————————————————————————————————————————–––––––––––––––––––––
## Public interface

(defn build-contact [name &keys {:category category :birthday birthday :last-contact last-contact}]
  (def category-val (cond
                     (keyword? category) category
                     (string? category) (keyword (string/ascii-lower category))
                     category))
  {:name name
   :category category-val
   :birthday birthday
   :last-contact last-contact})

(defn next-contact-date [contact]
  (if (and (contact :category) (contact :last-contact))
    (d/+days (contact :last-contact) (next-contact-periods (contact :category)))))
