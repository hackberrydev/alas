### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements commands runner.

(import ./commands/backup)
(import ./commands/insert_days)
(import ./commands/insert_task)
(import ./commands/list_contacts)
(import ./commands/remove_empty_days)
(import ./commands/report)
(import ./commands/schedule_contacts)
(import ./commands/schedule_tasks)
(import ./commands/stats)

(import ./date :as d)
(import ./errors)
(import ./schedule_parser)

# backup command needs to be first
# insert-task command needs to be after insert-days
# schedule-contacts command needs to be after insert-days
(def commands [backup/build-command
               insert_days/build-command
               insert_task/build-command
               list_contacts/build-command
               remove_empty_days/build-command
               report/build-command
               schedule_contacts/build-command
               schedule_tasks/build-command
               stats/build-command])

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn print-version
  ```
  Output version information.
  ```
  []
  (print "Alas version 1.5.1"))

(defn build-commands [arguments file-path]
  (filter any?
          (map (fn [build-command] (build-command arguments file-path))
               commands)))

(defn run-commands [plan file-path arguments]
  (def commands (build-commands arguments file-path))
  (def errors (filter identity (flatten (map (fn [c] (c :errors)) commands))))
  (var new-plan plan)
  (if (empty? errors)
    (set new-plan (reduce (fn [new-plan command-and-arguments]
                            (def command (first (command-and-arguments :command)))
                            (def arguments (drop 1 (command-and-arguments :command)))
                            (apply command new-plan arguments))
                         plan
                         commands)))
  {:plan new-plan :errors errors})
