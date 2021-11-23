### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../date :as d)
(import ../entities :as e)

(defn insert-days-in-list
  ```
  days must be non-empty.
  ```
  [days date today]
  (var new-days (reverse days))
  (var days-after-today @[])

  (while (and (any? new-days) (d/after? ((array/peek new-days) :date) today))
    (array/push days-after-today (array/pop new-days)))

  (var current-date (if (any? new-days) (d/next-day ((array/peek new-days) :date)) today))

  (while (d/before-or-eq? current-date date)
    (def new-day (if (and (any? days-after-today) (= current-date ((array/peek days-after-today) :date)))
                  (array/pop days-after-today)
                  (e/build-day current-date)))
    (array/push new-days new-day)
    (set current-date (d/next-day current-date)))

  (while (any? days-after-today)
    (array/push new-days (array/pop days-after-today)))
  (reverse new-days))

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
