### ————————————————————————————————————————————————————————————————————————————
### This module implements commands runner.

(import ./commands/backup :prefix "")
(import ./commands/insert_days :prefix "")
(import ./commands/remove_empty_days :prefix "")
(import ./commands/report :prefix "")
(import ./commands/schedule_tasks :prefix "")
(import ./commands/stats :prefix "")

(import ./date :as d)
(import ./file_repository)
(import ./schedule_parser)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn print-version
  ```
  Output version information.
  ```
  []
  (print "Alas version 0.2"))

(defn build-commands [arguments plan file-path]
  (def commands @[])
  (def insert-days-arg (arguments "insert-days"))
  # Backup command needs to be first.
  (if (not (arguments "skip-backup"))
    (array/push commands [backup file-path (d/today)]))
  # Keep commands sorted alphabetically.
  (if insert-days-arg
    (let [insert-days-count (parse insert-days-arg)]
      (if (number? insert-days-count)
        (array/push commands
                    [insert-days
                     (d/days-from-now (- insert-days-count 1))
                     (d/today)])
        (print "--insert-days argument in not a number."))))
  (if (arguments "remove-empty-days")
    (array/push commands
                [remove-empty-days (d/today)]))
  (if (arguments "report")
    (array/push commands
                [print-report (d/today) (parse (arguments "report"))]))
  # schedule-tasks has to be after insert-days and all other commands that
  # insert new days.
  (if (arguments "schedule-tasks")
    (let [file-path (arguments "schedule-tasks")
          load-file-result (file_repository/load file-path)
          error (load-file-result :error)]
      (if error
        (print error)
        (let [parse-result (schedule_parser/parse (load-file-result :text))]
          (if parse-result
            (array/push commands
                        [schedule-tasks (first parse-result) (d/today)])
            (print "Schedule could not be parsed."))))))
  (if (arguments "stats")
    (array/push commands [stats]))
  commands)

(defn run-commands [plan commands-and-arguments]
  (reduce (fn [new-plan command-and-arguments]
            (def command (first command-and-arguments))
            (def arguments (drop 1 command-and-arguments))
            (apply command new-plan arguments))
          plan
          commands-and-arguments))
