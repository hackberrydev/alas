### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-day [date line-number]
  {:date date :tasks (array) :changed false :line-number line-number})

(defn build-task [title done line-number]
  {:title title :done done :line-number line-number})
