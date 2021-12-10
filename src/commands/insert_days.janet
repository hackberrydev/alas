### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../plan)
(import ../day)

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
  (plan/insert-days plan (day/generate-days today date)))
