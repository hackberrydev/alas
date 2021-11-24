(import argparse :prefix "")
(import ./commands/stats :prefix "")
(import ./commands/insert_days :prefix "")
(import ./date :as d)
(import ./file_repository)
(import ./plan_serializer :as serializer)
(import ./plan_parser :as parser)

(def argparse-params
  ["A command line utility for planning your days"
   "stats" {:kind :flag
            :help "Show stats for the plan file."}
   "insert-days" {:kind :option
                  :help "Insert the following number of days into the plan."}
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
                                                   (d/today))))
        (print "Plan could not be parsed.")))))
