(import testament :prefix "" :exit true)

(import ../src/date :as d)
(import ../src/day)
(import ../src/plan)
(import ../src/task)

(import ../src/commands/insert_days :prefix "")
(import ../src/commands/remove_empty_days :prefix "")

(import ../src/commands :prefix "")


## -----------------------------------------------------------------------------
## Setup

(def file-path "test/examples/todo.md")

## -----------------------------------------------------------------------------
## Test build-commands

(deftest build-commands-when-there-are-no-errors
  (def arguments {"skip-backup" true "report" "7" "stats" true})
  (def commands (build-commands arguments file-path))
  (is (= 2 (length commands)))
  (loop [command :in commands]
    (is (command :command))
    (is (not (command :errors)))))

(deftest build-commands-when-there-are-errors
  (def arguments {"skip-backup" true "report" "seven"})
  (def commands (build-commands arguments file-path))
  (is (= 1 (length commands)))
  (is ((first commands) :errors)))

(deftest build-commands-when-not-skipping-backup
  (def arguments {"report" "7"})
  (def commands (build-commands arguments file-path))
  (is (= 2 (length commands)))
  (is ((commands 0) :command))
  (is ((commands 1) :command)))

## -----------------------------------------------------------------------------
## Test run-commands

(deftest run-commands-with-valid-arguments
  (def today (d/today))
  (def plan (plan/build-plan
              :days @[(day/build-day today)
                      (day/build-day (d/date 2020 8 4))
                      (day/build-day (d/date 2020 8 2) @[]
                                     @[(task/build-task "Buy milk" true)])]))
  (def arguments {"skip-backup" true "remove-empty-days" true "insert-days" "3"})
  (def new-plan (run-commands plan file-path arguments))
  (def days (new-plan :days))
  (is (= 4 (length days)))
  (is (= (d/+days today 2) ((days 0) :date)))
  (is (= (d/+days today 1) ((days 1) :date)))
  (is (= today ((days 2) :date)))
  (is (= (d/date 2020 8 2) ((days 3) :date))))

(deftest run-commands-with-invalid-arguments
  (def today (d/today))
  (def plan (plan/build-plan
              :days @[(day/build-day today)
                      (day/build-day (d/date 2020 8 4))
                      (day/build-day (d/date 2020 8 2) @[]
                                     @[(task/build-task "Buy milk" true)])]))
  (def arguments {"skip-backup" true "remove-empty-days" true "insert-days" "three"})
  (def new-plan (run-commands plan file-path arguments))
  (def days (new-plan :days))
  (is (= 3 (length days)))
  (is (= today ((days 0) :date)))
  (is (= (d/date 2020 8 4) ((days 1) :date)))
  (is (= (d/date 2020 8 2) ((days 2) :date))))

(run-tests!)
