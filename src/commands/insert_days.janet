### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

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
  [todo date today])
