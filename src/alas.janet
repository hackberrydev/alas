(import argparse :prefix "")

(import ./commands/insert_days :prefix "")
(import ./commands/remove_empty_days :prefix "")
(import ./commands/stats :prefix "")

(import ./date :as d)
(import ./file_repository)
(import ./plan_parser :as parser)
(import ./plan_serializer :as serializer)

(def argparse-params
  ["A command line utility for planning your days"
   "stats" {:kind :flag
            :help "Show stats for the plan file."}
   "insert-days" {:kind :option
                  :help "Insert the following number of days into the plan."}
   "remove-empty-days" {:kind :flag
                        :help "Remove past days without events or tasks."}
   :default {:kind :option}])

(defn- run-command [plan file-path command & arguments]
  (def new-plan (apply command plan arguments))
  (def plan-string (serializer/serialize new-plan))
  (file_repository/save-plan plan-string file-path))

(defn main [& args]
  (def arguments (argparse ;argparse-params))
  (def file-path (arguments :default))
  (def load-file-result (file_repository/load-plan file-path))
  (def error (load-file-result :error))
  (if error
    (print error)
    (let [parse-result (parser/parse (load-file-result :plan))]
      (if parse-result
        (let [plan (first parse-result)]
          (cond
            (arguments "stats") (print (formatted-stats (plan :days)))
            (arguments "insert-days") (run-command plan
                                                   file-path
                                                   insert-days
                                                   (d/days-from-now (- (parse (arguments "insert-days")) 1))
                                                   (d/today))
            (arguments "remove-empty-days") (run-command plan
                                                         file-path
                                                         remove-empty-days
                                                         (d/today))))
        (print "Plan could not be parsed.")))))
