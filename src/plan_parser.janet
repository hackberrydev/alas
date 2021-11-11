### ————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses plan as a string into
### entities.

(import ./entities :as e)

(def plan-grammar
  ~{:main (replace (* :title :inbox :days) ,e/build-plan)
    :title (* "# " :sentence)
    :inbox (* :inbox-title "\n" :tasks)
    :inbox-title (* "## Inbox\n")
    :days (replace (any :day) ,array)
    :day (drop (* :day-title "\n" :tasks))
    :day-title (* "## " :date ", " :week-day "\n")
    :date (* :d :d :d :d "-" :d :d "-" :d :d)
    :week-day (+ "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday" "Sunday")
    :tasks (group (any :task))
    :task (replace (* "- " (constant :done) :checkbox " " (constant :title) :sentence) ,struct)
    :checkbox (+ :checkbox-done :checkbox-pending)
    :checkbox-done (* (constant true) (+ "[x]" "[X]"))
    :checkbox-pending (* (constant false) "[ ]")
    :sentence (replace (capture (some (+ :w+ :s+))) ,string/trim)})

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn parse
  ```
  Parses plan string and returns plan as entities.
  ```
  [plan-string]
  (peg/match plan-grammar plan-string))
