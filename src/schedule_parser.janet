### ————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses schedule string into
### task entities.

(import ./task)

(def schedule-grammar
  ~{:main (* (drop :title) :tasks)
    :title (* "# " (some (+ :w+ :s+)))
    :tasks (group (any :task))
    :task (replace (* "- " :task-title :task-schedule (? "\n")) ,task/build-scheduled-task)
    :task-title (replace (capture (some (if-not "(" 1))) ,string/trim)
    :task-schedule (* "(" (replace (capture (some (+ :w+ :s+ "-"))) ,string/trim) ")")})

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn parse
  ```
  Parses schedule string and returns an array of task entities.
  ```
  [schedule-string]
  (peg/match schedule-grammar schedule-string))
