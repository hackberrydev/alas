(use judge)

(import ../../src/date :as "d")
(import ../../src/day)
(import ../../src/plan)
(import ../../src/commands/insert_days :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test insert-days

(deftest "insert day at the top"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 3))
                                     (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-1 (first (new-plan :days)))
  (test (length (new-plan :days)) 3)
  (test (day-1 :date)
        {:day 4 :month 8 :week-day "Tuesday" :year 2020})
  (test (empty? (day-1 :tasks)) true))

(deftest "insert three days at the top"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 3))
                                     (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 7) (d/date 2020 8 5)))
  (def day-1 (first (new-plan :days)))
  (test (length (new-plan :days)) 5)
  (test (day-1 :date)
        {:day 7 :month 8 :week-day "Friday" :year 2020}))

(deftest "insert days in the middle"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 6))
                                     (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (test (length (new-plan :days)) 3)
  (test (day-2 :date)
        {:day 4 :month 8 :week-day "Tuesday" :year 2020}))

(deftest "insert days when today already exists"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 6))
                                     (day/build-day (d/date 2020 8 4))]))
  (def new-plan (insert-days plan (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (test (length (new-plan :days)) 3)
  (test (day-2 :date)
        {:day 5 :month 8 :week-day "Wednesday" :year 2020}))

(deftest "insert days with empty todo"
  (def plan (plan/build-plan))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (test (length (new-plan :days)) 1)
  (test ((first (new-plan :days)) :date)
        {:day 4 :month 8 :week-day "Tuesday" :year 2020}))

(deftest "insert days with one day in the future"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 6))]))
  (def new-plan (insert-days plan(d/date 2020 8 5) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (test (length (new-plan :days)) 3)
  (test (day-2 :date)
        {:day 5 :month 8 :week-day "Wednesday" :year 2020}))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "without matching arguments"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "with correct arguments"
  (def arguments {"insert-days" "3"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))

(deftest "with incorrect arguments"
  (def arguments {"insert-days" "three"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--insert-days argument is not a number."))
