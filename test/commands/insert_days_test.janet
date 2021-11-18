(import testament :prefix "" :exit true)
(import ../../src/entities :as "e")
(import ../../src/date :as "d")
(import ../../src/commands/insert_days :as "c")

(defn- build-test-plan [days]
  (e/build-plan "Plan" @[] days))

(deftest insert-day-at-top
  (def plan (build-test-plan @[(e/build-day (d/date 2020 8 3))
                               (e/build-day (d/date 2020 8 2))]))
  (def new-plan (c/insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-1 (first (new-plan :days)))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) (day-1 :date))))

(deftest insert-three-days-at-top
  (def plan (build-test-plan @[(e/build-day (d/date 2020 8 3))
                               (e/build-day (d/date 2020 8 2))]))
  (def new-plan (c/insert-days plan (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-1 (first (new-plan :days)))
  (is (= 5 (length (new-plan :days))))
  (is (= (d/date 2020 8 6) (day-1 :date))))

(deftest insert-days-in-middle
  (def plan (build-test-plan @[(e/build-day (d/date 2020 8 6))
                               (e/build-day (d/date 2020 8 2))]))
  (def new-plan (c/insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 4 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) (day-2 :date))))

(deftest insert-days-when-today-already-exists
  (def plan (build-test-plan @[(e/build-day (d/date 2020 8 6))
                               (e/build-day (d/date 2020 8 4))]))
  (def new-plan (c/insert-days plan (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 5) (day-2 :date))))

(deftest insert-days-with-empty-todo
  (def plan (build-test-plan @[]))
  (def new-plan (c/insert-days plan (d/date 2020 8 4) (d/date 2020 8 4)))
  (is (= 1 (length (new-plan :days))))
  (is (= (d/date 2020 8 4) ((first (new-plan :days)) :date))))

(deftest insert-days-with-one-day-in-future
  (def plan (build-test-plan @[(e/build-day (d/date 2020 8 6))]))
  (def new-plan (c/insert-days plan(d/date 2020 8 5) (d/date 2020 8 4)))
  (def day-2 ((new-plan :days) 1))
  (is (= 3 (length (new-plan :days))))
  (is (= (d/date 2020 8 5) (day-2 :date))))

(run-tests!)
