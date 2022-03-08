### ————————————————————————————————————————————————————————————————————————————
### This module implements serializing a plan into a string.

(import ./date :as date)

(defn- plan-title [plan]
  (string "# " (plan :title)))

(defn- checkbox [done]
  (if done "[X]" "[ ]"))

(defn- serialize-event [event]
  (string "- " (event :text)))

(defn- serialize-task [task]
  (string "- " (checkbox (task :done)) " " (task :title)))

(defn- plan-inbox [plan serialize-empty-inbox]
  (if (any? (plan :inbox))
    (array/concat @["\n## Inbox\n"] (map serialize-task (plan :inbox)))
    (if serialize-empty-inbox
      ["\n## Inbox"]
      [])))

(defn- day-title [day new-line]
  (def title (string "\n## " (date/format (day :date))))
  (if new-line
    (string title "\n")
    title))

(defn- serialize-day [day]
  (def events (map serialize-event (day :events)))
  (def tasks (map serialize-task (day :tasks)))
  (def new-line (or (any? events) (any? tasks)))
  (array/concat @[(day-title day new-line)] events tasks))

(defn- serialize-days [days]
  (flatten (map serialize-day days)))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn serialize
  ```
  Serializes plan into a string.
  ```
  [plan &opt options]
  (default options {})
  (def serialize-empty-inbox (get options :serialize-empty-inbox false))
  (def plan-lines @[])
  (array/push plan-lines (plan-title plan))
  (array/concat plan-lines (plan-inbox plan serialize-empty-inbox))
  (array/concat plan-lines (serialize-days (plan :days)))
  (string (string/join plan-lines "\n") "\n"))
