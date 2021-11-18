### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../date :as d)
(import ../entities :as e)

(defn insert-days-in-list
  ```
  todo must be non-empty.
  ```
  [todo date today]
  (var new-todo (reverse todo))
  (var days-after-today @[])

  (while (and (any? new-todo) (d/after? ((array/peek new-todo) :date) today))
    (array/push days-after-today (array/pop new-todo)))

  (var current-date (if (any? new-todo) (d/next-day ((array/peek new-todo) :date)) today))

  (while (d/before-or-eq? current-date date)
    (def new-day (if (and (any? days-after-today) (= current-date ((array/peek days-after-today) :date)))
                  (array/pop days-after-today)
                  (e/build-day current-date true)))
    (array/push new-todo new-day)
    (set current-date (d/next-day current-date)))

  (while (any? days-after-today)
    (array/push new-todo (array/pop days-after-today)))
  (reverse new-todo))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn insert-days
  ```
  Inserts new days into the plan.

  (insert-days plan date today)

  plan  - The plan entity.
  date  - The date up to which new days will be generated.
  today - Date.
  ```
  [plan date today]
  (def days (plan :days))
  (def new-days (if (any? days)
                 (insert-days-in-list days date today)
                 @[(e/build-day today)]))
  (e/build-plan (plan :title) (plan :inbox) new-days))
