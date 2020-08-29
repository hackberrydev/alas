(import tester :prefix "" :exit true)
<<<<<<< HEAD:test/commands/stats_test.janet
(import ../../src/commands/stats :prefix "")
=======
(import test/utils :as "test")
(import src/commands :as "commands")
>>>>>>> 4584e18... Add spec for commands/insert-date:test/commands_test.janet

(def example-file "test/examples/todo.md")

(print "Test commands/stats")
(deftest
  (test "Stats command"
        (is (=
             "2 days\n3 completed tasks\n1 pending task"
<<<<<<< HEAD:test/commands/stats_test.janet
             (stats "test/examples/todo.md"))))
  (test "TODO file does not exist"
        (is (=
             "File does not exist"
             (stats "missing_file.md")))))
=======
             (commands/stats example-file))))
  (test "TODO file does not exist"
        (is (=
             "File does not exist"
             (commands/stats "missing_file.md")))))

(print "Test commands/insert-date")
(deftest
  (do
    (test/backup-file example-file)
    (commands/insert-date "## 2020-08-02, Sunday" example-file)
    (test "Insert date at the top"
          (is (=
               ```
               # Main TODO

               ## 2020-08-02, Sunday

               ## 2020-08-01, Saturday

               - [ ] Develop photos for the grandmother
               - [X] Pay bills

               ## 2020-07-31, Friday

               - [X] Review open pull requests
               - [X] Fix flaky test
               ```
               (file/read (file/open example-file) :all))))
    (test/restore-file example-file)))
>>>>>>> 4584e18... Add spec for commands/insert-date:test/commands_test.janet
