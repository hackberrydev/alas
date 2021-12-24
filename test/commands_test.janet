(import testament :prefix "" :exit true)

(import ../src/date :as d)
(import ../src/day)
(import ../src/plan)
(import ../src/task)

(import ../src/commands/insert_days :prefix "")
(import ../src/commands/remove_empty_days :prefix "")

(import ../src/commands :prefix "")

(deftest run-multiple-commands
  (def today (d/date 2020 8 5))
  (def plan (plan/build-plan "Plan" @[]
                             @[(day/build-day (d/date 2020 8 6))
                               (day/build-day (d/date 2020 8 4))
                               (day/build-day (d/date 2020 8 3))
                               (day/build-day (d/date 2020 8 2) @[]
                                              @[(task/build-task "Buy milk" true)])]))
  (def commands @[[remove-empty-days today]
                  [insert-days (d/date 2020 8 7) today]])
  (def new-plan (run-commands plan commands))
  (def new-days (new-plan :days))
  (is (= 4 (length new-days)))
  (is (= (d/date 2020 8 7) ((new-days 0) :date)))
  (is (= (d/date 2020 8 6) ((new-days 1) :date)))
  (is (= (d/date 2020 8 5) ((new-days 2) :date)))
  (is (= (d/date 2020 8 2) ((new-days 3) :date))))

(run-tests!)
