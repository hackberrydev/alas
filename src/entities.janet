### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

(defn build-day [date &opt changed]
  (default changed false)
  {:date date :tasks (array) :changed changed})

(defn build-task [title done]
  {:title title :done done})
