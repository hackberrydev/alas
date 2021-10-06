(import testament :prefix "" :exit true)
(import ../src/file_repository :as "file-repository")

(deftest read-lines-from-file
  (let [result (file-repository/read-lines "test/examples/todo.md")
        lines (result :lines)]
    (is (= 12 (length lines)))))

(deftest read-lines-from-file-that-does-not-exist
  (let [result (file-repository/read-lines "missing_file.md")]
    (is (= "File does not exist" (result :error)))))

(run-tests!)
