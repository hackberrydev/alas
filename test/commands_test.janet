(import tester :prefix "" :exit true)
(import src/commands :as "commands")

(deftest
  (test "Stats command"
        (is (=
             "2 days\n3 completed tasks\n1 pending task"
             (commands/stats "test/examples/todo.md"))))
  (test "TODO file does not exist"
        (is (=
             "File does not exist"
             (commands/stats "missing_file.md")))))
