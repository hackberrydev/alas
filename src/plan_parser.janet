### ————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses plan as a string into
### entities.

(import ./date :as d)
(import ./day)
(import ./event)
(import ./plan)
(import ./plan_serializer)

(def plan-grammar
  ~{:main (replace (* (constant :title) :title (? (* (constant :inbox) :inbox)) (constant :days) :days) ,plan/build-plan)
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
    :event (replace (* :event-begin :event-body) ,event/build-event)
    :event-begin (* "- " (if-not "[" 0))
    :event-body (replace (capture (some (if-not (+ :event-begin :task-begin) 1))) ,string/trim)
    :tasks (group (any :task))
    :task (replace (* (constant :done) :task-begin " " (constant :title) :task-body) ,struct)
    :task-begin (* "- " :checkbox)
    :checkbox (+ :checkbox-done :checkbox-pending)
    :checkbox-done (* (+ "[x]" "[X]") (constant true))
    :checkbox-pending (* "[ ]" (constant false))
    :task-body (replace (capture (some (if-not (+ :day-title :task-begin) 1))) ,string/trim)})

(defn- lines-count [plan-string]
  (def count (length (filter (fn [line] (not= line "\n"))
                             (string/split "\n" plan-string))))
  (if (= (last plan-string) 10) # line feed (\n)
    (- count 1)
    count))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn serialize-empty-inbox? [plan-string]
  (truthy? (string/find "## Inbox" plan-string)))

(defn parse
  ```
  Parses plan string and returns plan as entities.
  ```
  [plan-string]
  (def serialize-empty-inbox (serialize-empty-inbox? plan-string))
  (def parse-result (peg/match plan-grammar plan-string))
  (if parse-result
    (let [plan (first parse-result)
          parsed-plan-string (plan_serializer/serialize
                               plan
                               {:serialize-empty-inbox serialize-empty-inbox})
          parsed-lines-count (lines-count parsed-plan-string)]
      (if (= parsed-lines-count  (lines-count plan-string))
        {:plan plan}
        {:error (string "Plan can not be parsed: last parsed line is line "
                        parsed-lines-count)}))
    {:error "Plan can not be parsed"}))
