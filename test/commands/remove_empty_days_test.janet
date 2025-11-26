(use judge)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/remove_empty_days :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test remove-empty-days

(deftest "removes empty days in the past"
  (def plan
    (plan/build-plan
      :days @[(day/build-day (d/date 2020 8 7))
              (day/build-day (d/date 2020 8 5))
              (day/build-day (d/date 2020 8 4))
              (day/build-day (d/date 2020 8 3) @[]
                             @[(task/build-task "Buy milk" :checked)])]))
  (def new-plan (remove-empty-days plan (d/date 2020 8 6)))
  (test (length (new-plan :days)) 2)
  (test (((new-plan :days) 0) :date)
        {:day 7 :month 8 :week-day "Friday" :year 2020})
  (test (((new-plan :days) 1) :date)
        {:day 3 :month 8 :week-day "Monday" :year 2020}))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "doesn't build the command when arguments are not matching"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "builds the command when arguments are matching"
  (def arguments {"remove-empty-days" true})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))
