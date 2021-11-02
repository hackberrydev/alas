### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-todo [header days]
  {:header header :days days})

(defn build-day [date &opt changed]
  (default changed false)
  {:date date :tasks (array) :changed changed})

(defn build-task [title done]
  {:title title :done done})
