### ————————————————————————————————————————————————————————————————————————————
### The main file.

(import argparse :prefix "")

(import ./commands/backup :prefix "")
(import ./commands/insert_days :prefix "")
(import ./commands/remove_empty_days :prefix "")
(import ./commands/report :prefix "")
(import ./commands/schedule_tasks :prefix "")
(import ./commands/stats :prefix "")
(import ./commands :prefix "")

(import ./date :as d)
(import ./file_repository)
(import ./plan_parser)
(import ./plan_serializer)
(import ./schedule_parser)

# Keep commands sorted alphabetically.
(def argparse-params
  ["A command line utility for planning your days"
   "insert-days" {:kind :option
                  :help "Insert the following number of days into the plan."}
   "remove-empty-days" {:kind :flag
                        :help "Remove past days without events or tasks."}
   "report" {:kind :option
             :help "Print tasks for the selected number of days."}
   "schedule-tasks" {:kind :option
                     :help "Schedule tasks from a list of tasks in a file."}
   "skip-backup" {:kind :flag
                  :help "Don't create a backup."}
   "stats" {:kind :flag
            :help "Show stats for the plan file."}
   "version" {:kind :flag
              :short "v"
              :help "Output version information."}
   :default {:kind :option}])

(defn- build-commands [arguments plan file-path]
  (def commands @[])
  # Backup command needs to be first.
  (if (not (arguments "skip-backup"))
    (array/push commands [backup file-path (d/today)]))
  # Keep commands sorted alphabetically.
  (if (arguments "insert-days")
    (array/push commands
                [insert-days
                 (d/days-from-now (- (parse (arguments "insert-days")) 1))
                 (d/today)]))
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

(defn- run-with-file-path [arguments file-path]
  (def load-file-result (file_repository/load file-path))
  (def error (load-file-result :error))
  (if error
    (print error)
    (let [parse-result (plan_parser/parse (load-file-result :text))]
      (if parse-result
        (let [plan (first parse-result)
              commands (build-commands arguments plan file-path)]
          (file_repository/save
            (plan_serializer/serialize (run-commands plan commands))
            file-path))
        (print "Plan could not be parsed.")))))

(defn- run-with-arguments [arguments]
  (def file-path (arguments :default))
  (if file-path
    (run-with-file-path arguments file-path)
    (if (arguments "version")
      (print-version)
      (print "Plan file path missing."))))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn main [& args]
  (def arguments (argparse ;argparse-params))
  (if arguments
    (run-with-arguments arguments)))
