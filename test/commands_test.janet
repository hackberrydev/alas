(import tester :prefix "" :exit true)
(import src/commands :as "commands")

(deftest
  (test "stats command"
        (is (=
             "2 days\n3 completed tasks\n1 pending task"
             (commands/stats "test/examples/todo.md")))))
