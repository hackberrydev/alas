(import testament :prefix "" :exit true)
(import ../src/plan)
(import ../src/day)
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

(deftest has-day
  (def plan (plan/build-plan "My Plan"
                             @[]
                             @[(day/build-day (d/date 2020 7 31))]))
  (is (plan/has-day? plan (d/date 2020 7 31)))
  (is (not (plan/has-day? plan (d/date 2020 8 1)))))

(run-tests!)
