### ————————————————————————————————————————————————————————————————————————————
### This module implements command for inserting new days in a TODO.

(import ../date :as "d")
(import ../entities :as "e")

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn insert-days
  ```
  Inserts new days into the array of day entities.

  (insert-days days date)

  days  - The list of day entities.
  date  - The date up to which new days will be generated.
  ```
  [todo date]
  (var new-todo (reverse todo))
  (var line-number ((array/peek new-todo) :line-number))
  (array/push new-todo
              (e/build-day date line-number true))
  (reverse new-todo))
