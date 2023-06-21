(use judge)

(import ../src/date :as d)
(import ../src/event)
(import ../src/task)
(import ../src/day :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test generate-days

(deftest "generates days from the first date to the second date"
  (def days (generate-days (d/date 2020 8 2) (d/date 2020 8 5)))
  (test (length days) 4)
  (test (= (d/date 2020 8 5) ((days 0) :date)) true)
  (test (= (d/date 2020 8 4) ((days 1) :date)) true)
  (test (= (d/date 2020 8 3) ((days 2) :date)) true)
  (test (= (d/date 2020 8 2) ((days 3) :date)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test empty-day?

(deftest "checks if the day doesn't have any tasks"
  (test (empty-day? (build-day (d/date 2020 8 1))) true)
  (test (not (empty-day? (build-day (d/date 2020 8 1)
                                    @[(event/build-event "Visited museum")]
                                    @[])))
        true)
  (test (not (empty-day? (build-day (d/date 2020 8 1)
                                    @[]
                                    @[(task/build-task "Buy milk" true)])))
        true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test add-tasks

(deftest "adds tasks to the day"
  (def day (build-day (d/date 2020 8 1)))
  (add-tasks day @[(task/build-task "Buy milk" true)
                   (task/build-task "Fix the lamp" false)])
  (test (length (day :tasks)) 2)
  (test (((day :tasks) 0) :title) "Buy milk")
  (test (((day :tasks) 1) :title) "Fix the lamp"))

(deftest "doesn't add duplicate tasks"
  (def day (build-day (d/date 2020 8 1)
                      @[]
                      @[(task/build-task "Fix the lamp" false)]))
  (add-tasks day @[(task/build-task "Buy milk" true)
                   (task/build-task "Fix the lamp" false)])
  (test (length (day :tasks)) 2)
  (test (((day :tasks) 0) :title) "Fix the lamp")
  (test (((day :tasks) 1) :title) "Buy milk"))
