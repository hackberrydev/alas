### ————————————————————————————————————————————————————————————————————————————
### This module implements commands runner.

(import ./commands/backup)
(import ./commands/insert_days)
(import ./commands/remove_empty_days)
(import ./commands/report)
(import ./commands/schedule_tasks)
(import ./commands/stats)

(import ./date :as d)
(import ./file_repository)
(import ./schedule_parser)

# TODO: Add backup command
# backup command needs to be first
(def commands [insert_days/build-command
               remove_empty_days/build-command
               report/build-command
               schedule_tasks/build-command
               stats/build-command])

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn print-version
  ```
  Output version information.
  ```
  []
  (print "Alas version 0.2"))

(defn build-commands [arguments file-path]
  (filter any?
          (map (fn [build-command] (build-command arguments file-path))
               commands)))

(defn run-commands [plan file-path arguments]
  (def commands (build-commands arguments file-path))
  (reduce (fn [new-plan command-and-arguments]
            (def command (first (command-and-arguments :command)))
            (def arguments (drop 1 (command-and-arguments :command)))
            (apply command new-plan arguments))
          plan
          commands))
