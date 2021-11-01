### ————————————————————————————————————————————————————————————————————————————
### This module implements functions for parsing a TODO string to entities and
### serializing entities to a string.

(import ./date :as date)
(import ./entities :as e)

(defn- day-title? [day]
  (string/has-prefix? "## 2" day))

(defn- day-title [day]
  (string "## " (date/format (day :date)) "\n"))

(defn- build-day [line]
  (def date (date/parse (string/trim ((string/split " " line) 1) ",")))
  (e/build-day date))

(defn- add-day [days line]
  (array/push days (build-day line)))

(defn- task? [line]
  (string/has-prefix? "- [" line))

(defn- build-task [line]
  (def title (string/slice line 6))
  (def done (string/has-prefix? "- [x]" (string/ascii-lower line)))
  (e/build-task title done))

(defn- add-task [days line]
  (def day (array/peek days))
  (def task (build-task line))
  (if day
    (array/push (day :tasks) task)))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load
  ```
  Loads days and tasks from a string to an array.
  ```
  [todo]
  (def lines (string/split "\n" todo))
  (def days @[])
  (loop [line :in lines]
    (cond
      (day-title? line) (add-day days line)
      (task? line)      (add-task days line)))
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
  (loop [line :in todo-lines]
    (while day
      (array/push new-todo-lines (day-title day))
      (set day (array/pop days)))
    (array/push new-todo-lines line))
  (string/join new-todo-lines "\n"))
