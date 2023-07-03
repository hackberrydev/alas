(use judge)

(import ../../src/date)
(import ../../src/file_repository)
(import ../../src/commands/backup :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test backup-path

(deftest "when file doesn't exist"
  (test (backup-path "test/examples/plan.md" (date/date 2020 8 1))
        "test/examples/plan-2020-08-01.md"))

(deftest "when plan path begins with dot"
  (test (backup-path "./test/examples/plan.md" (date/date 2020 8 1))
        "./test/examples/plan-2020-08-01.md")
  (test (backup-path "./test/examples/plan.md" (date/date 2020 8 2))
        "./test/examples/plan-2020-08-02-1.md"))

(deftest "when plan path begins with two dots"
  (test (backup-path "../alas/test/examples/plan.md" (date/date 2020 8 1))
        "../alas/test/examples/plan-2020-08-01.md")
  (test (backup-path "../alas/test/examples/plan.md" (date/date 2020 8 2))
        "../alas/test/examples/plan-2020-08-02-1.md"))

(deftest "when file exists"
  (test (backup-path "test/examples/plan.md" (date/date 2020 8 2))
        "test/examples/plan-2020-08-02-1.md")
  (test (backup-path "test/examples/plan.md" (date/date 2020 8 3))
        "test/examples/plan-2020-08-03-2.md"))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test backup

(deftest "backup plan"
  (def plan-path "test/examples/todo.md")
  (def backup-path "test/examples/todo-2020-08-01.md")
  (def plan (file_repository/load plan-path))
  (backup plan plan-path (date/date 2020 8 1))
  (test (table? (os/stat backup-path)) true)
  (os/rm backup-path))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "when not skipping backup"
  (def arguments {"stats" true})
  (def result (build-command arguments "test/examples/plan.md"))
  (test (tuple? (result :command)) true))

(deftest "when skipping backup"
  (def arguments {"skip-backup" true "stats" true})
  (def result (build-command arguments "test/examples/plan.md"))
  (test (empty? result) true))
