### ————————————————————————————————————————————————————————————————————————————
### This module implements serializing a plan into a string.

(import ./date :as date)

(defn- plan-title [plan]
  (string "# " (plan :title) "\n"))

(defn- inbox-title []
  "## Inbox\n")

(defn- checkbox [done]
  (if done "[X]" "[ ]"))

(defn- serialize-event [event]
  (string "- " (event :text)))

(defn- serialize-task [task]
  (string "- " (checkbox (task :done)) " " (task :title)))

(defn- day-title [day]
  (string "\n## " (date/format (day :date)) "\n"))

(defn- serialize-day [day]
  (array/concat @[(day-title day)]
                (map serialize-event (day :events))
                (map serialize-task (day :tasks))))

(defn- serialize-days [days]
  (flatten (map serialize-day days)))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn serialize
  ```
  Serializes plan into a string.
  ```
  [plan]
  (def plan-lines @[])
  (array/push plan-lines (plan-title plan))
  (array/push plan-lines (inbox-title))
  (array/concat plan-lines (map serialize-task (plan :inbox)))
  (array/concat plan-lines (serialize-days (plan :days)))
  (string/join plan-lines "\n"))
