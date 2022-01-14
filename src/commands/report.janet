### ————————————————————————————————————————————————————————————————————————————
### This module implements report command.

(import ../date)
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn report
  ```
  Returns tasks from the selected number of days, excluding tasks from today.
  ```
  [plan date days-count]
  (def start-date (date/-days date days-count))
  (def end-date (date/-days date 1))
  (def tasks (sorted-by (fn [task] (task :title))
                        (plan/tasks-between plan start-date end-date)))
  (def unique-tasks @[])
  (loop [task :in tasks
         :when (or (empty? unique-tasks)
                   (not (= (task :title) ((array/peek unique-tasks) :title))))]
    (array/push unique-tasks task))
  unique-tasks)
