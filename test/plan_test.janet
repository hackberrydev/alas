(import testament :prefix "" :exit true)

(import ../src/plan)
(import ../src/day)
(import ../src/task)
(import ../src/event)
(import ../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test day-with-date

(deftest day-with-date
  (def day-1 (day/build-day (d/date 2020 7 15)))
  (def day-2 (day/build-day (d/date 2020 7 16)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (is (= day-1 (plan/day-with-date plan (d/date 2020 7 15)))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test has-day-with-date?

(deftest has-day-with-date?
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 7 31))]))
  (is (plan/has-day-with-date? plan (d/date 2020 7 31)))
  (is (not (plan/has-day-with-date? plan (d/date 2020 8 1)))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test empty-days

(deftest empty-days
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" true)]))
  (def day-3 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[]))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def empty-days (plan/empty-days plan))
  (is (= day-1 (empty-days 0)))
  (is (= day-4 (empty-days 1))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test sort-days

(deftest sort-days
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 7 31))
                                     (day/build-day (d/date 2020 8 1))]))
  (def new-plan (plan/sort-days plan))
  (is (= (d/date 2020 8 1) (((new-plan :days) 0) :date)))
  (is (= (d/date 2020 7 31) (((new-plan :days) 1) :date))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test insert-days

(deftest insert-days
  (def plan (plan/build-plan))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (is (= 2 (length new-days)))
  (is (= (d/date 2020 8 1) ((new-days 0) :date)))
  (is (= (d/date 2020 7 31) ((new-days 1) :date))))

(deftest insert-days-with-duplicates
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 7 31))]))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (is (= 2 (length new-days)))
  (is (= (d/date 2020 8 1) ((new-days 0) :date)))
  (is (= (d/date 2020 7 31) ((new-days 1) :date))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test remove-days

(deftest remove-days
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" true)]))
  (def day-3 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[]))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def new-plan (plan/remove-days plan @[day-2 day-4]))
  (def new-days (new-plan :days))
  (is (= 2 (length new-days)))
  (is (= day-1 (new-days 0)))
  (is (= day-3 (new-days 1))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-before

(deftest days-before
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-before plan (d/date 2020 8 4)))
  (is (= 2 (length days)))
  (if (>= (length days) 2)
    (do
      (is (= day-3 (days 0)))
      (is (= day-4 (days 1))))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-after

(deftest days-after
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-after plan (d/date 2020 8 3)))
  (is (= 2 (length days)))
  (if (>= (length days) 2)
    (do
      (is (= day-1 (days 0)))
      (is (= day-2 (days 1))))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-on-or-after

(deftest days-on-or-after
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)))
  (def day-3 (day/build-day (d/date 2020 8 3)))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def days (plan/days-on-or-after plan (d/date 2020 8 4)))
  (is (= 2 (length days)))
  (is (= day-1 (days 0)))
  (is (= day-2 (days 1))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test all-days

(deftest all-days
  (def day-1 (day/build-day (d/date 2020 8 6)))
  (def day-2 (day/build-day (d/date 2020 8 3)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (def days (plan/all-days plan))
  (is (= 4 (length days)))
  (if (= 4 (length days))
    (do
      (is (d/equal? (d/date 2020 8 6) ((days 0) :date)))
      (is (d/equal? (d/date 2020 8 5) ((days 1) :date)))
      (is (d/equal? (d/date 2020 8 4) ((days 2) :date)))
      (is (d/equal? (d/date 2020 8 3) ((days 3) :date))))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test all-tasks

(deftest all-tasks
  (def day-1 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" true)]))
  (def day-2 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[(task/build-task "Review PRs" false)]))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (def tasks (plan/all-tasks plan))
  (is (= 2 (length tasks)))
  (is (= "Buy milk" ((tasks 0) :title)))
  (is (= "Review PRs" ((tasks 1) :title))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test tasks-between

(deftest tasks-between
  (def day-1 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Task 1" true)]))
  (def day-2 (day/build-day (d/date 2020 8 3)
                            @[]
                            @[(task/build-task "Task 2" false)]))
  (def day-3 (day/build-day (d/date 2020 8 2)
                            @[]
                            @[(task/build-task "Task 3" false)]))
  (def day-4 (day/build-day (d/date 2020 8 1)
                            @[]
                            @[(task/build-task "Task 4" false)]))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3 day-4]))
  (def tasks (plan/tasks-between plan (d/date 2020 8 2) (d/date 2020 8 3)))
  (is (= 2 (length tasks)))
  (is (= "Task 2" ((tasks 0) :title)))
  (is (= "Task 3" ((tasks 1) :title))))

(run-tests!)
