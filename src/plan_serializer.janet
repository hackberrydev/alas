### ————————————————————————————————————————————————————————————————————————————
### This module implements functions for parsing a TODO string to entities and
### serializing entities to a string.

(import ./date :as date)

(defn- day-title [day]
  (string "## " (date/format (day :date)) "\n"))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn save
  ```
  Serializes days and tasks from an array into a string.
  ```
  [days todo]
  (def days (reverse days)) # This way `days` can be used as a stack.
  (def todo-lines (string/split "\n" todo))
  (def new-todo-lines @[])
  (var day (array/pop days))
  (loop [line :in todo-lines]
    (while day
      (array/push new-todo-lines (day-title day))
      (set day (array/pop days)))
    (array/push new-todo-lines line))
  (string/join new-todo-lines "\n"))
