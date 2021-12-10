### ————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses plan as a string into
### entities.

(import ./date :as d)
(import ./entities :as e)
(import ./day)
(import ./plan)

(def plan-grammar
  ~{:main (replace (* :title :inbox :days) ,plan/build-plan)
    :title (* "# " :sentence)
    :sentence (replace (capture (some (+ :w+ :s+))) ,string/trim)
    :inbox (* :inbox-title "\n" :tasks)
    :inbox-title (* "## Inbox\n")
    :days (group (any :day))
    :day (replace (* :day-title "\n" :events :tasks) ,day/build-day)
    :day-title (* "## " (replace :date ,d/parse) ", " :week-day "\n")
    :date (capture (* :d :d :d :d "-" :d :d "-" :d :d))
    :week-day (+ "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    :events (group (any :event))
    :event (replace (* :event-begin :event-body) ,e/build-event)
    :event-begin (* "- " (if-not "[" 0))
    :event-body (replace (capture (some (if-not (+ :event-begin :task-begin) 1))) ,string/trim)
    :tasks (group (any :task))
    :task (replace (* (constant :done) :task-begin " " (constant :title) :task-body) ,struct)
    :task-begin (* "- " :checkbox)
    :checkbox (+ :checkbox-done :checkbox-pending)
    :checkbox-done (* (+ "[x]" "[X]") (constant true))
    :checkbox-pending (* "[ ]" (constant false))
    :task-body (replace (capture (some (if-not (+ :day-title :task-begin) 1))) ,string/trim)})

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn parse
  ```
  Parses plan string and returns plan as entities.
  ```
  [plan-string]
  (peg/match plan-grammar plan-string))
