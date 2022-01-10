(import testament :prefix "" :exit true)
(import ../../src/date)
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

(run-tests!)
