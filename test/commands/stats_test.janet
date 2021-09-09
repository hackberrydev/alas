(import tester :prefix "" :exit true)
(import ../../src/commands/stats :prefix "")

(deftest
  (test "Stats command"
        (is (=
             "2 days\n3 completed tasks\n1 pending task"
             (stats "test/examples/todo.md"))))
  (test "TODO file does not exist"
        (is (=
             "File does not exist"
             (stats "missing_file.md")))))
