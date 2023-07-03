(use judge)

(import ../../src/commands/stats :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "doesn't build the command when arguments are not matching"
  (def arguments {"report" true})
  (test (empty? (build-command arguments)) true))

(deftest "builds the command when arguments are matching"
  (def arguments {"stats" true})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))
