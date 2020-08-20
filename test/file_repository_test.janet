(import tester :prefix "")
(import src/file_repository :as "file-repository")

# Test file-repository/read-lines
(deftest
  (test "Reading a file"
        (let [result (file-repository/read-lines "test/examples/todo.md")
              lines (result :lines)]
          (= (length lines) 12)))

  (test "Reading from a file that doesn't exist"
        (let [result (file-repository/read-lines "missing_file.md")]
          (= (result :error) "File does not exist."))))
