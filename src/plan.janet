### ————————————————————————————————————————————————————————————————————————————
### This module implements plan entity and related functions.

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

(defn insert-days [plan days]
  (array/concat (plan :days) days)
  plan)
