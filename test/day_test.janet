(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/event)
(import ../src/task)
(import ../src/day :prefix "")

(deftest generate-days
  (def days (generate-days (d/date 2020 8 2) (d/date 2020 8 5)))
  (is (= 4 (length days)))
  (is (= (d/date 2020 8 5) ((days 0) :date)))
  (is (= (d/date 2020 8 4) ((days 1) :date)))
  (is (= (d/date 2020 8 3) ((days 2) :date)))
  (is (= (d/date 2020 8 2) ((days 3) :date))))

(deftest empty-day?
  (is (empty-day? (build-day (d/date 2020 8 1))))
  (is (not (empty-day? (build-day (d/date 2020 8 1)
                                  @[(event/build-event "Visited museum")]
                                  @[]))))
  (is (not (empty-day? (build-day (d/date 2020 8 1)
                                  @[]
                                  @[(task/build-task "Buy milk" true)])))))

(run-tests!)
