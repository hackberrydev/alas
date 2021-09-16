(import argparse :prefix "")
(import ./commands/stats :prefix "")

(def argparse-params
  ["A command line utility for planning your days"
   "stats" {:kind :flag
            :help "Show stats for the plan file."}
   :default {:kind :option}])

(defn main [& args]
  (let [arguments (argparse ;argparse-params)
        file-path (arguments :default)]
    (cond
      (arguments "stats") (print (stats file-path)))))
