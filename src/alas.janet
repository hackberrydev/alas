(import argparse :prefix "")
(import ./commands/stats :prefix "")
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
            (arguments "insert-days") (print "Inserting days...")))
        (print "Plan could not be parsed.")))))
