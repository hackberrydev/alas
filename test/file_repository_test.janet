(import testament :prefix "" :exit true)
(import ../src/file_repository :as "file-repository")

(deftest load-todo-from-file
  (let [result (file-repository/load-todo "test/examples/todo.md")
        todo (result :todo)]
    (is (= 12 (length (string/split "\n" todo))))))

(deftest load-todo-from-file-that-does-not-exist
  (let [result (file-repository/load-todo "missing_file.md")]
    (is (= "File does not exist" (result :error)))))

(run-tests!)
