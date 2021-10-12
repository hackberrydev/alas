### ————————————————————————————————————————————————————————————————————————————
### This module implements functions for parsing a TODO string to entities and
### serializing entities to a string.

(import ./date :as date)
(import ./entities :as e)

(defn- day-title? [day]
  (string/has-prefix? "## 2" day))

(defn- day-title [day]
  (string "## " (date/format (day :date)) "\n"))

(defn- build-day [line line-number]
  (def date (date/parse (string/trim ((string/split " " line) 1) ",")))
  (e/build-day date line-number))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load
  ```
  Loads days and tasks from a string to an array.
  ```
  [todo]
  (def lines (string/split "\n" todo))
  (def days @[])
  (var line-number 0)
  (loop [line :in lines
         :after (++ line-number)]
    (if (day-title? line)
      (array/push days (build-day line line-number))))
  days)

(defn save
  ```
  Serializes days and tasks from an array into a string.
  ```
  [days todo]
  (def days (reverse days)) # This way `days` can be used as a stack.
  (def todo-lines (string/split "\n" todo))
  (def new-todo-lines @[])
  (var day (array/pop days))
  (var line-number 0)
  (loop [line :in todo-lines
         :after (++ line-number)]
    (while (and day (= (day :line-number) line-number))
      (array/push new-todo-lines (day-title day))
      (set day (array/pop days)))
    (array/push new-todo-lines line))
  (string/join new-todo-lines "\n"))
