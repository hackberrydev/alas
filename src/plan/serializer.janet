### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements serializing a plan into a string.

(import ../date)

(def body-indentation "  ")

(defn- plan-title [plan]
  (string "# " (plan :title)))

(defn- checkbox [done]
  (if done "[X]" "[ ]"))

(defn- serialize-event-title [event]
  (string "- " (event :title)))

(defn- serialize-event-body [event]
  (def body (event :body))
  (if (or (nil? body) (empty? body))
    ""
    (string "\n"
            (string/join
              (map (fn [line] (string body-indentation line)) body)
              "\n"))))

(defn- serialize-event [event]
  (string
    (serialize-event-title event)
    (serialize-event-body event)))

(defn- task-mark [task]
  (if (task :missed-on)
    (string " (missed on " (date/format (task :missed-on) true) ")")
    ""))

(defn- serialize-task-title [task]
  (string "- " (checkbox (task :done)) " " (task :title) (task-mark task)))

(defn- serialize-task-body [task]
  (def body (task :body))
  (if (or (nil? body) (empty? body))
    ""
    (string "\n"
            (string/join
              (map (fn [line] (string body-indentation line)) body)
              "\n"))))

(defn- serialize-task [task]
  (string
    (serialize-task-title task)
    (serialize-task-body task)))

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

## —————————————————————————————————————————————————————————————————————————————————————————————————
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
