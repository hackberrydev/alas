(use judge)

(import ../src/alas)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test run-with-file-path

(deftest "returns exit status 0 when there were no errors"
  (let [arguments {"skip-backup" true "stats" true}
        [errors exit-status] (alas/run-with-file-path arguments "./test/examples/todo.md")]
    (test (empty? errors) true)
    (test exit-status 0)))

(deftest "returns exit status 3 when there are file errors"
  (let [arguments {"skip-backup" true "stats" true}
        [errors exit-status] (alas/run-with-file-path arguments "./test/examples/missing-todo.md")]
    (test (empty? errors) false)
    (test exit-status 3)))

(deftest "returns exit status 4 when there are parsing errors"
  (let [arguments {"skip-backup" true "stats" true}
        [errors exit-status] (alas/run-with-file-path arguments "./test/examples/unparsable-todo.md")]
    (test (empty? errors) false)
    (test exit-status 4)))
