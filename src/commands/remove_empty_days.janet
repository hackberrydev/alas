### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a plan.

(import ../date)
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn remove-empty-days
  ```
  Removes empty days from plan that are before today.
  ```
  [plan today]
  (def empty-days (filter (fn [day] (date/before? (day :date) today))
                          (plan/empty-days plan)))
  (plan/remove-days plan empty-days))
