### ————————————————————————————————————————————————————————————————————————————
### This module implements functions for parsing a TODO string to entities and
### serializing entities to a string.

(import ./date :as date)
(import ./entities :as e)

(defn- day-title? [day]
  (string/has-prefix? "## 2" day))

(defn- day-title [day]
  (def date (day :date))
  (string/format "## %d-%d-%d" (date :year) (date :month) (date :day)))

(defn- build-day [line line-number]
  {:date (date/parse (string/trim ((string/split " " line) 1) ","))
   :line-number line-number
   :changed false})

(defn- parse-line
  [todo-lines days &opt line-number]
  (default line-number -1)
  (if (empty? todo-lines)
    days
    (let [line (array/pop todo-lines)
          line-number (+ 1 line-number)]
      (if (day-title? line)
        (parse-line todo-lines
                    (array/insert days -1 (build-day line line-number))
                    line-number)
        (parse-line todo-lines days line-number)))))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load
  ```
  Loads days and tasks from a string to an array.
  ```
  [todo]
  (parse-line (reverse (string/split "\n" todo)) @[]))

(defn save
  ```
  Serializes days and tasks from an array into a string.
  ```
  [days todo]
  (def days (reverse days)) # This way `days` can be used as an array.
  (def todo-lines (string/split "\n" todo))
  (def new-todo-lines @[])
  (var day (array/pop days))
  (var current-line 0)
  (each line todo-lines
        (while (and day (= (day :line-number) current-line))
          (array/push new-todo-lines (day-title day))
          (set day (array/pop days)))
        (array/push new-todo-lines line)
        (++ current-line))
  (string/join new-todo-lines "\n"))
