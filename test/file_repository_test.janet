(import tester :prefix "" :exit true)
(import ../src/file_repository :as "file-repository")

(print "Test file-repository/read-lines")
(deftest
  (test "Reading a file"
        (let [result (file-repository/read-lines "test/examples/todo.md")
              lines (result :lines)]
          (is (= 12 (length lines)))))

  (test "Reading from a file that doesn't exist"
        (let [result (file-repository/read-lines "missing_file.md")]
          (is (= "File does not exist" (result :error))))))

(print "Test file-repository/load-todo")
(deftest
  (test "Reading days from a file"
        (let [schedule (file-repository/load-todo "test/examples/todo.md")]
          (is (= 2 (length  (schedule :days))))))

  (test "Reading schedule details from a file"
        (let [schedule (file-repository/load-todo "test/examples/todo.md")
              day-1 (get (schedule :days) 0)
              day-2 (get (schedule :days) 1)]
          (is (= "2020-08-01, Saturday" (day-1 :date)))
          (is (= "- [ ] Develop photos for the grandmother"(get  (day-1 :tasks) 0)))
          (is (= "- [X] Pay bills"(get  (day-1 :tasks) 1)))
          (is (= "2020-07-31, Friday" (day-2 :date)))
          (is (= "- [X] Review open pull requests"(get  (day-2 :tasks) 0)))
          (is (= "- [X] Fix flaky test"(get  (day-2 :tasks) 1)))))

  (test "Reading from a file that doesn't exist"
        (let [result (file-repository/load-todo "missing_file.md")]
          (is (= "File does not exist" (result :error))))))
