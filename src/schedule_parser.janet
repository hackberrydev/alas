### ————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses schedule string into
### task entities.

(import ./task)

(def schedule-grammar
  ~{:main (* (drop :title) :tasks)
    :title (* "# " (some (+ :w+ :s+)) "\n")
    :tasks (group (any :task))
    :task (replace (* "- " :task-title :task-schedule) ,task/build-scheduled-task)})

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn parse
  ```
  Parses schedule string and returns an array of task entities.
  ```
  [schedule-string]
  (peg/match schedule-grammar schedule-string))
