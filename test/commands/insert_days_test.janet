(import testament :prefix "" :exit true)
(import ../../src/date :as "d")
(import ../../src/day)
(import ../../src/plan)
(import ../../src/commands/insert_days :prefix "")

## -----------------------------------------------------------------------------
## Test insert-days

(defn- build-test-plan [days]
  (plan/build-plan "Plan" @[] days))

(deftest insert-day-at-top
  (def plan (build-test-plan @[(day/build-day (d/date 2020 8 3))
                               (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-1 (first (new-plan :days)))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) (day-1 :date)))
  (is (empty? (day-1 :tasks))))

(deftest insert-three-days-at-top
  (print "insert-three-days-at-top")
  (def plan (build-test-plan @[(day/build-day (d/date 2020 8 3))
                               (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 7) (d/date 2020 8 5)))
  (def day-1 (first (new-plan :days)))
  (is (= 5 (length (new-plan :days))))
  (is (= (d/date 2020 8 7) (day-1 :date))))

(deftest insert-days-in-middle
  (def plan (build-test-plan @[(day/build-day (d/date 2020 8 6))
                               (day/build-day (d/date 2020 8 2))]))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) (day-2 :date))))

(deftest insert-days-when-today-already-exists
  (def plan (build-test-plan @[(day/build-day (d/date 2020 8 6))
                               (day/build-day (d/date 2020 8 4))]))
  (def new-plan (insert-days plan (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 5) (day-2 :date))))

(deftest insert-days-with-empty-todo
  (def plan (build-test-plan @[]))
  (def new-plan (insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (is (= 1 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) ((first (new-plan :days)) :date))))

(deftest insert-days-with-one-day-in-future
  (def plan (build-test-plan @[(day/build-day (d/date 2020 8 6))]))
  (def new-plan (insert-days plan(d/date 2020 8 5) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 5) (day-2 :date))))

## -----------------------------------------------------------------------------
## Test build-command

(deftest build-command-without-matching-arguments
  (def arguments {"stats" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"insert-days" "3"})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(deftest build-command-with-incorrect-arguments
  (def arguments {"insert-days" "three"})
  (def result (build-command arguments))
  (is (nil? (result :command)))
  (is (= "--insert-days argument is not a number." (first (result :errors)))))

(run-tests!)
