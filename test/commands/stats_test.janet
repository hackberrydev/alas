(import testament :prefix "" :exit true)
(import ../../src/commands/stats :prefix "")

(deftest stats-command-for-file
  (is (=
       "2 days\n3 completed tasks\n1 pending task"
       (stats "test/examples/todo.md"))))

(deftest stats-command-for-file-that-does-not-exist
  (is (=
       "File does not exist"
       (stats "missing_file.md"))))
