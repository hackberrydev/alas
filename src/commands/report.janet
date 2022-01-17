### ————————————————————————————————————————————————————————————————————————————
### This module implements report command.

(import ../date)
(import ../plan)

(defn- unique-tasks [tasks]
  (def unique-tasks @[])
  (def sorted-tasks  (sorted-by (fn [task] (task :title)) tasks))
  (loop [task :in sorted-tasks
         :when (or (empty? unique-tasks)
                   (not (= (task :title) ((array/peek unique-tasks) :title))))]
    (array/push unique-tasks task))
  unique-tasks)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn report
  ```
  Returns tasks from the selected number of days, excluding tasks from today.
  ```
  [plan date days-count]
  (def start-date (date/-days date days-count))
  (def end-date (date/-days date 1))
  (unique-tasks (plan/tasks-between plan start-date end-date)))
