### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn remove-empty-days
  ```
  Removes empty days from plan that are before today.
  ```
  [plan today]
  (def empty-days (plan/empty-days plan))
  (plan/remove-days empty-days))
