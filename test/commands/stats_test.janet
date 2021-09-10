(import tester :prefix "" :exit true)
(import test/utils :as "test")
(import ../../src/commands/stats :prefix "")

(def example-file "test/examples/todo.md")

(print "Test commands/stats")
(deftest
  (test "Stats command"
        (is (=
             "2 days\n3 completed tasks\n1 pending task"
             (stats "test/examples/todo.md"))))
  (test "TODO file does not exist"
        (is (=
             "File does not exist"
             (stats "missing_file.md")))))

(print "Test commands/insert-date")
(deftest
  (do
    (test/backup-file example-file)
    (insert-date "## 2020-08-02, Sunday" example-file)
    (test "Insert date at the top"
          (is (=
               (string/join
                 ["# Main TODO\n"
                  "## 2020-08-02, Sunday\n"
                  "## 2020-08-01, Saturday\n"
                  "- [ ] Develop photos for the grandmother"
                  "- [X] Pay bills\n"
                  "## 2020-07-31, Friday\n"
                  "- [X] Review open pull requests"
                  "- [X] Fix flaky test\n"]
                 "\n")
               (string (file/read (file/open example-file) :all)))))
    (test/restore-file example-file)))
