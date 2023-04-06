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
  Parses schedule-string and returns a tuple:

  - {:tasks tasks}    Where tasks is an array of task entities, when parsing was successfull.
  - {:errors errors}  Where errors is an array of strings.
  ```
  [schedule-string]
  (let [parse-result (peg/match schedule-grammar schedule-string)]
    (if parse-result
      (let [tasks (first parse-result)]
        (if (empty? tasks)
          {:errors ["Schedule is empty"]}
          {:tasks tasks}))
      {:errors ["Schedule can not be parsed"]})))
