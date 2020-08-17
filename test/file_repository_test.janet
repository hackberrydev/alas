(import tester :prefix "")
(import src/file_repository :as "file-repository")

(deftest
  (test "Reading a file"
        (let [result (file-repository/read-file "test/examples/todo.md")
              lines (result :lines)]
          (= (length lines) 7))))
