(import testament :prefix "" :exit true)

(import ../../src/commands/stats :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest build-command-without-matching-argument
  (def arguments {"report" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"stats" true})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(run-tests!)
