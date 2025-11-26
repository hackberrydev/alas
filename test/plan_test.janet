(use judge)

(import ../src/plan)
(import ../src/day)
(import ../src/task)
(import ../src/event)
(import ../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test day-with-date

(deftest "finds the day with the date in the plan"
  (def day-1 (day/build-day (d/date 2020 7 15)))
  (def day-2 (day/build-day (d/date 2020 7 16)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (test (= (plan/day-with-date plan (d/date 2020 7 15)) day-1) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test has-day-with-date?

(deftest "checks if the plan has a day with the date"
  (def day (day/build-day (d/date 2020 7 31)))
  (def plan (plan/build-plan :days @[day]))
  (test (= (plan/has-day-with-date? plan (d/date 2020 7 31)) day) true)
  (test (not (plan/has-day-with-date? plan (d/date 2020 8 1))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test empty-days

(deftest "finds days without any tasks in the plan"
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" :checked)]))
  (def day-3 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[]))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def empty-days (plan/empty-days plan))
  (test (= (empty-days 0) day-1) true)
  (test (= (empty-days 1) day-4) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test sort-days

(deftest "sorts days by date ascending"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 7 31))
                                     (day/build-day (d/date 2020 8 1))]))
  (def new-plan (plan/sort-days plan))
  (test (= (((new-plan :days) 0) :date) (d/date 2020 8 1)) true)
  (test (= (((new-plan :days) 1) :date) (d/date 2020 7 31)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test insert-days

(deftest "inserts new days in the plan"
  (def plan (plan/build-plan))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (test (length new-days) 2)
  (test (= ((new-days 0) :date) (d/date 2020 8 1)) true)
  (test (= ((new-days 1) :date) (d/date 2020 7 31)) true))

(deftest "doens't insert duplicate days"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 7 31))]))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (test (length new-days) 2)
  (test (= (d/date 2020 8 1) ((new-days 0) :date)) true)
  (test (= (d/date 2020 7 31) ((new-days 1) :date)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test remove-days

(deftest "removes days from the plan"
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" :checked)]))
  (def day-3 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[]))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def new-plan (plan/remove-days plan @[day-2 day-4]))
  (def new-days (new-plan :days))
  (test (length new-days) 2)
  (test (= day-1 (new-days 0)) true)
  (test (= day-3 (new-days 1)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-before

(deftest "returns all days befor the date"
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-before plan (d/date 2020 8 4)))
  (test (length days) 2)
  (if (>= (length days) 2)
    (do
      (test (= day-3 (days 0)) true)
      (test (= day-4 (days 1)) true))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-after

(deftest "returns all days after the date"
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-after plan (d/date 2020 8 3)))
  (test (length days) 2)
  (if (>= (length days) 2)
    (do
      (test (= day-1 (days 0)) true)
      (test (= day-2 (days 1)) true))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-on-or-after

(deftest "returns days with the date or after the date"
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-on-or-after plan (d/date 2020 8 4)))
  (test (length days) 2)
  (test (= day-1 (days 0)) true)
  (test (= day-2 (days 1)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test all-days

(deftest "returns all days from the plan"
  (def day-1 (day/build-day (d/date 2020 8 6)))
  (def day-2 (day/build-day (d/date 2020 8 3)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (def days (plan/all-days plan))
  (test (length days) 4)
  (if (= 4 (length days))
    (do
      (test (d/equal? (d/date 2020 8 6) ((days 0) :date)) true)
      (test (d/equal? (d/date 2020 8 5) ((days 1) :date)) true)
      (test (d/equal? (d/date 2020 8 4) ((days 2) :date)) true)
      (test (d/equal? (d/date 2020 8 3) ((days 3) :date)) true))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test all-days-before

(deftest "returns all days before the date and it generates new days for 'holes'"
  (def day-1 (day/build-day (d/date 2020 8 6)))
  (def day-2 (day/build-day (d/date 2020 8 3)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (def days (plan/all-days-before plan (d/date 2020 8 5)))
  (test (length days) 2)
  (if (= 2 (length days))
    (do
      (test (d/equal? (d/date 2020 8 4) ((days 0) :date)) true)
      (test (d/equal? (d/date 2020 8 3) ((days 1) :date)) true))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test all-tasks

(deftest "returns all tasks from the plan"
  (def day-1 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" :checked)]))
  (def day-2 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[(task/build-task "Review PRs" :open)]))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (def tasks (plan/all-tasks plan))
  (test (length tasks) 2)
  (test ((tasks 0) :title) "Buy milk")
  (test ((tasks 1) :title) "Review PRs"))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test tasks-between

(deftest "returns all tasks from the days between 2 dates"
  (def day-1 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Task 1" :checked)]))
  (def day-2 (day/build-day (d/date 2020 8 3)
                            @[]
                            @[(task/build-task "Task 2" :open)]))
  (def day-3 (day/build-day (d/date 2020 8 2)
                            @[]
                            @[(task/build-task "Task 3" :open)]))
  (def day-4 (day/build-day (d/date 2020 8 1)
                            @[]
                            @[(task/build-task "Task 4" :open)]))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def tasks (plan/tasks-between plan (d/date 2020 8 2) (d/date 2020 8 3)))
  (test (length tasks) 2)
  (test ((tasks 0) :title) "Task 2")
  (test ((tasks 1) :title) "Task 3"))
