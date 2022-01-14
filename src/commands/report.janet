### ————————————————————————————————————————————————————————————————————————————
### This module implements report command.

(import ../date)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn report
  ```
  Returns tasks from the selected number of days.
  ```
  [plan date days-count]
  (def start-date (date/-days date days-count))
  (plan/tasks-between start-date date))
