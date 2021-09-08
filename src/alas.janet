(import ./commands :as "commands")

(defn main [& args]
  (if (= (length args) 3)
    (let [command (get args 1)
          file-path (get args 2)]
      (if (= command "stats")
        (print (commands/stats file-path))))
    (print "Invalid arguments")))
