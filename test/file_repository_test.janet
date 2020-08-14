(import tester :prefix "")
(import src/file-repository :as "file-repository")

(deftest
  (test "Reading a file"
        (let [lines (file-repository/read-file "text/examples/todo.md")]
          (= (length lines) 7))))
