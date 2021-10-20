### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../date :as d)
(import ../entities :as e)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn insert-days
  ```
  Inserts new days into the array of day entities.

  (insert-days days date today)

  days  - The list of day entities.
  date  - The date up to which new days will be generated.
  today - Date.
  ```
  [todo date today]
  (var new-todo (reverse todo))
  (var days-after-today @[])

  (while (d/after? ((array/peek new-todo) :date) today)
    (array/push days-after-today (array/pop new-todo)))

  (var line-number ((array/peek new-todo) :line-number))
  (var current-date (d/next-day ((array/peek new-todo) :date)))

  (while (d/before-or-eq? current-date date)
    (def new-day (if (and (any? days-after-today) (= current-date (array/peek days-after-today) :date))
                  (array/pop days-after-today)
                  (e/build-day current-date line-number true)))
    (array/push new-todo new-day)
    (set current-date (d/next-day current-date))
    (set line-number ((array/peek new-todo) :line-number)))

  (while (any? days-after-today)
    (array/push new-todo (array/pop days-after-today)))
  (reverse new-todo))
