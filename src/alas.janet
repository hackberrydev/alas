### ————————————————————————————————————————————————————————————————————————————————————————————————
### The main file.

(import argparse :prefix "")

(import ./commands :prefix "")

(import ./file_repository)
(import ./plan/parser :as plan_parser)
(import ./plan/serializer :as plan_serializer)

# Keep commands sorted alphabetically.
(def argparse-params
  ["A command line utility for planning your days"
   "insert-days" {:kind :option
                  :help "Insert the following number of days into the plan."}
   "list-contacts" {:kind :option
                    :help "List all contacts."}
   "remove-empty-days" {:kind :flag
                        :help "Remove past days without events or tasks."}
   "report" {:kind :option
             :help "Print tasks for the selected number of days."}
   "schedule-contacts" {:kind :option
                        :help "Schedule contacts to be contacted today."}
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

(defn- run-with-file-path [arguments file-path]
  (def load-file-result (file_repository/load file-path))
  (def error (load-file-result :error))
  (if error
    (print error)
    (let [plan-string (load-file-result :text)
          parse-result (plan_parser/parse plan-string)
          parse-error (parse-result :error)
          plan (parse-result :plan)]
      (if parse-error
        (print parse-error)
        (let [serialize-empty-inbox (plan_parser/serialize-empty-inbox? plan-string)
              new-plan (run-commands plan file-path arguments)
              new-plan-string (plan_serializer/serialize
                                new-plan
                                {:serialize-empty-inbox serialize-empty-inbox})]
          (file_repository/save new-plan-string file-path))))))

(defn- run-with-arguments [arguments]
  (def file-path (arguments :default))
  (if file-path
    (run-with-file-path arguments file-path)
    (if (arguments "version")
      (print-version)
      (print "Plan file path missing."))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn main [& args]
  (def arguments (argparse ;argparse-params))
  (if arguments
    (run-with-arguments arguments)))
