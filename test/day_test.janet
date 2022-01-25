(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/event)
(import ../src/task)
(import ../src/day :prefix "")

## -----------------------------------------------------------------------------
## Test generate-days

(deftest generate-days
  (def days (generate-days (d/date 2020 8 2) (d/date 2020 8 5)))
  (is (= 4 (length days)))
  (is (= (d/date 2020 8 5) ((days 0) :date)))
  (is (= (d/date 2020 8 4) ((days 1) :date)))
  (is (= (d/date 2020 8 3) ((days 2) :date)))
  (is (= (d/date 2020 8 2) ((days 3) :date))))

## -----------------------------------------------------------------------------
## Test empty-day?

(deftest empty-day?
  (is (empty-day? (build-day (d/date 2020 8 1))))
  (is (not (empty-day? (build-day (d/date 2020 8 1)
                                  @[(event/build-event "Visited museum")]
                                  @[]))))
  (is (not (empty-day? (build-day (d/date 2020 8 1)
                                  @[]
                                  @[(task/build-task "Buy milk" true)])))))

## -----------------------------------------------------------------------------
## Test add-tasks

(deftest add-tasks
  (def day (build-day (d/date 2020 8 1)))
  (add-tasks day @[(task/build-task "Buy milk" true)
                   (task/build-task "Fix the lamp" false)])
  (is (= 2 (length (day :tasks))))
  (is (= "Buy milk") (((day :tasks) 0) :title))
  (is (= "Fix the lamp") (((day :tasks) 1) :title)))

(run-tests!)
