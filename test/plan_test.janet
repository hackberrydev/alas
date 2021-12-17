(import testament :prefix "" :exit true)
(import ../src/plan)
(import ../src/day)
(import ../src/task)
(import ../src/event)
(import ../src/date :as d)

(deftest insert-days
  (def plan (plan/build-plan "My Plan" @[] @[]))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (is (= 2 (length new-days)))
  (is (= (d/date 2020 8 1) ((new-days 0) :date)))
  (is (= (d/date 2020 7 31) ((new-days 1) :date))))

(deftest insert-days-with-duplicates
  (def plan (plan/build-plan "My Plan"
                             @[]
                             @[(day/build-day (d/date 2020 7 31))]))
  (def days @[(day/build-day (d/date 2020 8 1))
              (day/build-day (d/date 2020 7 31))])
  (def new-plan (plan/insert-days plan days))
  (def new-days (new-plan :days))
  (is (= 2 (length new-days)))
  (is (= (d/date 2020 8 1) ((new-days 0) :date)))
  (is (= (d/date 2020 7 31) ((new-days 1) :date))))

(deftest sort-days
  (def plan (plan/build-plan "My Plan"
                             @[]
                             @[(day/build-day (d/date 2020 7 31))
                               (day/build-day (d/date 2020 8 1))]))
  (def new-plan (plan/sort-days plan))
  (is (= (d/date 2020 8 1) (((new-plan :days) 0) :date)))
  (is (= (d/date 2020 7 31) (((new-plan :days) 1) :date))))

(deftest has-day
  (def plan (plan/build-plan "My Plan"
                             @[]
                             @[(day/build-day (d/date 2020 7 31))]))
  (is (plan/has-day? plan (d/date 2020 7 31)))
  (is (not (plan/has-day? plan (d/date 2020 8 1)))))

(deftest empty-days
  (def day-1 (day/build-day (d/date 2020 8 5)))
  (def day-2 (day/build-day (d/date 2020 8 4)
                            @[]
                            @[(task/build-task "Buy milk" true)]))
  (def day-3 (day/build-day (d/date 2020 8 3)
                            @[(event/build-event "Visited museum")]
                            @[]))
  (def day-4 (day/build-day (d/date 2020 8 2)))
  (def plan (plan/build-plan "My Plan"
                             @[]
                             @[day-1 day-2 day-3 day-4]))
  (def empty-days (plan/empty-days plan))
  (is (= day-1 (empty-days 0)))
  (is (= day-4 (empty-days 1))))

(run-tests!)
