(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/remove_empty_days :prefix "")

## -----------------------------------------------------------------------------
## Test remove-empty-days

(deftest remove-empty-days-in-past
  (def plan
    (plan/build-plan
      :days @[(day/build-day (d/date 2020 8 7))
              (day/build-day (d/date 2020 8 5))
              (day/build-day (d/date 2020 8 4))
              (day/build-day (d/date 2020 8 3) @[]
                             @[(task/build-task "Buy milk" true)])]))
  (def new-plan (remove-empty-days plan (d/date 2020 8 6)))
  (is (= 2 (length (new-plan :days))))
  (is (= (d/date 2020 8 7) (((new-plan :days) 0) :date)))
  (is (= (d/date 2020 8 3) (((new-plan :days) 1) :date))))

## -----------------------------------------------------------------------------
## Test build-command

(deftest build-command-without-matching-argument
  (def arguments {"stats" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"remove-empty-days" true})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(run-tests!)
