(use judge)

(import ../src/date :as d)
(import ../src/day)
(import ../src/plan)
(import ../src/task)

(import ../src/commands/insert_days :prefix "")
(import ../src/commands/remove_empty_days :prefix "")

(import ../src/commands :prefix "")


## —————————————————————————————————————————————————————————————————————————————————————————————————
## Setup

(def file-path "test/examples/todo.md")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-commands

(deftest "when there are no errors"
  (def arguments {"skip-backup" true
                  "report" "7"
                  "stats" true
                  "list-contacts" "test/examples/contacts"})
  (def commands (build-commands arguments file-path))
  (test (length commands) 3)
  (loop [command :in commands]
    (test (not (nil? (command :command))) true)
    (test (nil? (command :errors)) true)))

(deftest "when there are errors"
  (def arguments {"skip-backup" true "report" "seven"})
  (def commands (build-commands arguments file-path))
  (test (length commands) 1)
  (test (not (nil? ((first commands) :errors))) true))

(deftest"when not skipping backup"
  (def arguments {"report" "7"})
  (def commands (build-commands arguments file-path))
  (test (length commands) 2)
  (test (not (nil? ((commands 0) :command))) true)
  (test (not (nil? ((commands 1) :command))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test run-commands

(deftest "with valid arguments"
  (def today (d/today))
  (def plan (plan/build-plan
              :days @[(day/build-day today)
                      (day/build-day (d/date 2020 8 4))
                      (day/build-day (d/date 2020 8 2) @[]
                                     @[(task/build-task "Buy milk" :checked)])]))
  (def arguments {"skip-backup" true "remove-empty-days" true "insert-days" "3"})
  (def {:plan new-plan :errors errors} (run-commands plan file-path arguments))
  (def days (new-plan :days))
  (test (empty? errors) true)
  (test (length days) 4)
  (test (= (d/+days today 2) ((days 0) :date)) true)
  (test (= (d/+days today 1) ((days 1) :date)) true)
  (test (= today ((days 2) :date)) true)
  (test (= (d/date 2020 8 2) ((days 3) :date)) true))

(deftest "with invalid arguments"
  (def today (d/today))
  (def plan (plan/build-plan
              :days @[(day/build-day today)
                      (day/build-day (d/date 2020 8 4))
                      (day/build-day (d/date 2020 8 2) @[]
                                     @[(task/build-task "Buy milk" :checked)])]))
  (def arguments {"skip-backup" true "remove-empty-days" true "insert-days" "three"})
  (def {:plan new-plan :errors errors} (run-commands plan file-path arguments))
  (def days (new-plan :days))
  (test (length days) 3)
  (test (= today ((days 0) :date)) true)
  (test (= (d/date 2020 8 4) ((days 1) :date)) true)
  (test (= (d/date 2020 8 2) ((days 2) :date)) true)
  (test (= (first errors) "--insert-days argument is not a number.") true))
