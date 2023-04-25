### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses schedule string into
### task entities.

(import ./task)

(def schedule-grammar
  ~{:main (* (drop :title) :tasks)
    :title (* "# " (some (+ :w+ :s+)))
    :tasks (group (any :task))
    :task (replace (* "- " :task-title :task-schedule (? "\n")) ,task/build-scheduled-task)
    :task-title (replace (capture (some (if-not (+ "(" "\n") 1))) ,string/trim)
    :task-schedule (* "(" (replace (capture (some (+ :w+ :s+ "-"))) ,string/trim) ")")})

(defn- task-lines-count
  ```
  Returns the number of lines that start with '-' in the schedule string.
  ```
  [schedule-string]
  (length (filter (fn [line] (string/has-prefix? "-" line))
                  (string/split "\n" schedule-string))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
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
          (do
            (if (= (length tasks) (task-lines-count schedule-string))
              {:tasks tasks}
              {:errors [(string "Schedule can not be parsed - last parsed task is \""
                                ((last tasks) :title)
                                "\"")]}))))
      {:errors ["Schedule can not be parsed"]})))
