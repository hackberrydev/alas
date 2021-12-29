(import argparse :prefix "")

(import ./commands/backup :prefix "")
(import ./commands/insert_days :prefix "")
(import ./commands/remove_empty_days :prefix "")
(import ./commands/stats :prefix "")
(import ./commands :prefix "")

(import ./date :as d)
(import ./file_repository :prefix "")
(import ./plan_parser :as parser)
(import ./plan_serializer :as serializer)

(def argparse-params
  ["A command line utility for planning your days"
   "insert-days" {:kind :option
                  :help "Insert the following number of days into the plan."}
   "remove-empty-days" {:kind :flag
                        :help "Remove past days without events or tasks."}
   "skip-backup" {:kind :flag
                  :help "Don't create a backup."}
   "stats" {:kind :flag
            :help "Show stats for the plan file."}
   "version" {:kind :flag
              :short "v"
              :help "Output version information."}
   :default {:kind :option}])

(defn- build-commands [arguments plan]
  (def commands @[])
  # Backup command needs to be first.
  (if (not (arguments "skip-backup"))
    (array/push commands [backup]))
  (if (arguments "stats")
    (array/push commands [stats]))
  (if (arguments "insert-days")
    (array/push commands
                [insert-days
                 (d/days-from-now (- (parse (arguments "insert-days")) 1))
                 (d/today)]))
  (if (arguments "remove-empty-days")
    (array/push commands
                [remove-empty-days (d/today)]))
  commands)

(defn main [& args]
  (def arguments (argparse ;argparse-params))
  (def file-path (arguments :default))
  (if file-path
    (let [load-file-result (load-plan file-path)
          error (load-file-result :error)]
      (if error
        (print error)
        (let [parse-result (parser/parse (load-file-result :plan))]
          (if parse-result
            (let [plan (first parse-result)
                  commands (build-commands arguments plan)]
              (save-plan (serializer/serialize (run-commands plan commands))
                         file-path))
            (print "Plan could not be parsed.")))))
    (if (arguments "version")
      (print-version))))
