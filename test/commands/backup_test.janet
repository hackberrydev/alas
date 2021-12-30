(import testament :prefix "" :exit true)
(import ../../src/date)
(import ../../src/commands/backup :prefix "")

## -----------------------------------------------------------------------------
## Test backup-path

(deftest backup-path-when-file-does-not-exist
  (is (= "test/examples/plan-2020-08-01.md"
          (backup-path "test/examples/plan.md" (date/date 2020 8 1)))))

(run-tests!)
