(defn main [& args]
  (let [file (file/read (file/open "test/examples/todo.md") :all)
        lines (string/split "\n" file)]
    (print "The file has " (length lines) " lines.")
    (print "Lines:")
    (each line lines (print line))))
