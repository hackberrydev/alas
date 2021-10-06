(import testament :prefix "" :exit true)
(import ../src/file_repository :as "file-repository")

(deftest load-todo-from-file
  (let [result (file-repository/load-todo "test/examples/todo.md")
        todo (result :todo)]
    (is (= 12 (length (string/split "\n" todo))))))

(deftest load-todo-from-file-that-does-not-exist
  (let [result (file-repository/load-todo "missing_file.md")]
    (is (= "File does not exist" (result :error)))))

(deftest save-todo
  (def new-todo-path "test/examples/new_todo.md")
  (def todo

       ```
       # Main TODO

       ## Inbox

       - [ ] Fix the lamp

       ## 2020-08-03, Monday

       ## 2020-08-02, Sunday

       ## 2020-08-01, Saturday

       - [ ] Develop photos
       - [x] Pay bills

       ## 2020-07-31, Friday

       - [x] Review open pull requests
       - [x] Fix the flaky test
      ```)
  (file-repository/save-todo todo new-todo-path)
  (is (= todo ((file-repository/load-todo new-todo-path) :todo)))
  (os/rm new-todo-path))

(run-tests!)
