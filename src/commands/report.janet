### ————————————————————————————————————————————————————————————————————————————
### This module implements report command.

(import ../date)
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn report
  ```
  Returns tasks from the selected number of days, excluding tasks from today.
  ```
  [plan date days-count]
  (def start-date (date/-days date days-count))
  (def end-date (date/-days date 1))
  (plan/tasks-between plan start-date end-date))
