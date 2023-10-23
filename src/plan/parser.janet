### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses a plan as a string into entities.

(import ../date :as d)
(import ../day)
(import ../event)
(import ../plan)
(import ./serializer :as plan_serializer)

(def plan-grammar
  ~{:main (replace (* (constant :title) :title
                      (? "\n")
                      (? (* (constant :inbox) :inbox))
                      (constant :days) :days)
                   ,plan/build-plan)
    :title (* "# " :text-line "\n")
    :text-line (capture (to (+ "\n" -1)))
    :inbox
      {:main (* :inbox-title (? "\n") :tasks (? "\n"))
       :inbox-title (* "## Inbox" (? "\n"))}
    :days
      {:main (group (any :day))
       :day
         {:main (replace (* :day-title (? "\n") :events :tasks (? "\n")) ,day/build-day)
          :day-title (* "## " :date ", " :week-day (? "\n"))
          :week-day (+ "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
          :events
            {:main (group (any :event))
             :event
               {:main (replace (* :event-begin :text-line (? "\n")) ,event/build-event)
                :event-begin (* "- " (not "["))}}}}
    :tasks
      {:main (group (any :task))
       :task
         {:main (replace (* (constant :done) :task-begin
                            " "
                            (constant :title) (capture (some (if-not (+ "\n" " (missed on") 1)))
                            (? :task-missed-on-date)
                            (? "\n")
                            (constant :body) :task-body
                            (? "\n"))
                         ,struct)
          :task-begin
            {:main (* "- " :checkbox)
             :checkbox
               {:main (+ :checkbox-done :checkbox-pending)
                :checkbox-done (* (+ "[x]" "[X]") (constant true))
                :checkbox-pending (* "[ ]" (constant false))}}
          :task-missed-on-date (* " (missed on " (constant :missed-on) :date ")")
          :task-body
            {:main (group (any :task-body-line))
             :task-body-line (* "  " :text-line (? "\n"))}}}
    :date (replace (capture (* :d :d :d :d "-" :d :d "-" :d :d)) ,d/parse)})

(defn- lines-count [plan-string &opt options]
  (default options {:ignore-whitespace true})
  (def filter-function (if (options :ignore-whitespace)
                           (fn [line] (not= (string/trim line) ""))
                           (fn [_line] true)))
  (length (filter filter-function (string/split "\n" plan-string))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
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
                               {:serialize-empty-inbox serialize-empty-inbox})]
      (if (= (lines-count parsed-plan-string) (lines-count plan-string))
        {:plan plan}
        {:errors [(string "Plan can not be parsed: last parsed line is line "
                          (lines-count parsed-plan-string {:ignore-whitespace false}))]}))
    {:errors ["Plan can not be parsed"]}))
