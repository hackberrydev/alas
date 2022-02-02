(import testament :prefix "" :exit true)
(import ../../src/date)
(import ../../src/file_repository)
(import ../../src/commands/backup :prefix "")

## -----------------------------------------------------------------------------
## Test backup-path

(deftest backup-path-when-file-does-not-exist
  (is (= "test/examples/plan-2020-08-01.md"
          (backup-path "test/examples/plan.md" (date/date 2020 8 1)))))

(deftest backup-path-when-file-exists
  (is (= "test/examples/plan-2020-08-02-1.md"
         (backup-path "test/examples/plan.md" (date/date 2020 8 2))))
  (is (= "test/examples/plan-2020-08-03-2.md"
         (backup-path "test/examples/plan.md" (date/date 2020 8 3)))))

## -----------------------------------------------------------------------------
## Test backup

(deftest backup-plan
  (def plan-path "test/examples/todo.md")
  (def backup-path "test/examples/todo-2020-08-01.md")
  (def plan (file_repository/load plan-path))
  (backup plan plan-path (date/date 2020 8 1))
  (is (os/stat backup-path))
  (os/rm backup-path))

(run-tests!)
