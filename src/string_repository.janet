### ————————————————————————————————————————————————————————————————————————————
### This module implements functions for parsing a TODO string to entities and
### serializing entities to a string.

(import ./date :as date)
(import ./entities :as e)

(defn- day-title? [day]
  (string/has-prefix? "## 2" day))

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

(defn load
  ```
  Loads days and tasks from a string to an array.
  ```
  [todo]
  (parse-line (reverse (string/split "\n" todo)) @[]))
