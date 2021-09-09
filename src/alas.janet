(import ./commands/stats :prefix "")

(defn main [& args]
  (if (= (length args) 3)
    (let [command (get args 1)
          file-path (get args 2)]
      (if (= command "stats")
        (print (stats file-path))))
    (print "Invalid arguments")))
