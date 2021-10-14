### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-day [date line-number &opt changed]
  (default changed false)
  {:date date :tasks (array) :changed changed :line-number line-number})

(defn build-task [title done line-number]
  {:title title :done done :line-number line-number})
