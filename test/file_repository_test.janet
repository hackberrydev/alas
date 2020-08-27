(import tester :prefix "")
(import src/file_repository :as "file-repository")

(print "Test file-repository/read-lines")
(deftest
  (test "Reading a file"
        (let [result (file-repository/read-lines "test/examples/todo.md")
              lines (result :lines)]
          (= (length lines) 12)))

  (test "Reading from a file that doesn't exist"
        (let [result (file-repository/read-lines "missing_file.md")]
          (= (result :error) "File does not exist."))))

(print "Test file-repository/read-schedule")
(deftest
  (test "Reading days from a file"
        (let [schedule (file-repository/read-schedule "test/examples/todo.md")]
          (= (length (schedule :days)) 2)))

  (test "Reading schedule details from a file"
        (let [schedule (file-repository/read-schedule "test/examples/todo.md")
              day-1 (get (schedule :days) 0)
              day-2 (get (schedule :days) 1)]
          (= (day-1 :date) "2020-08-01")
          (= (get (day-1 :tasks) 0) "- [ ] Develop photos for the grandmother")
          (= (get (day-1 :tasks) 1) "- [X] Pay bills")
          (= (day-2 :date) "2020-07-31")
          (= (get (day-2 :tasks) 0) "- [X] Review open pull requests")
          (= (get (day-2 :tasks) 1) "- [X] Fix flaky test")))

  (test "Reading from a file that doesn't exist"
        (let [result (file-repository/read-schedule "missing_file.md")]
          (= (result :error) "File does not exist."))))
