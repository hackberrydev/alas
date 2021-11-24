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
  (var today-or-future @[])
  (var current-date today)

  (while (and (any? new-days) (d/after-or-eq? ((array/peek new-days) :date) today))
    (array/push today-or-future (array/pop new-days)))

  (while (d/before-or-eq? current-date date)
    (def new-day (if (and (any? today-or-future)
                          (= current-date ((array/peek today-or-future) :date)))
                  (array/pop today-or-future)
                  (e/build-day current-date)))
    (array/push new-days new-day)
    (set current-date (d/next-day current-date)))

  (while (any? today-or-future)
    (array/push new-days (array/pop today-or-future)))
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
