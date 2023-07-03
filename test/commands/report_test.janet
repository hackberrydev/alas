(use judge)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/report :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test report

(deftest "returns the specified number of tasks"
  (def plan
    (plan/build-plan
      :days @[(day/build-day (d/date 2020 8 7) @[]
                             @[(task/build-task "Task 1" true)])
              (day/build-day (d/date 2020 8 6) @[]
                             @[(task/build-task "Task 2" true)
                               (task/build-task "Task 3" true)])
              (day/build-day (d/date 2020 8 5) @[]
                             @[(task/build-task "Task 3" true)
                               (task/build-task "Task 4" true)])
              (day/build-day (d/date 2020 8 4) @[]
                             @([(task/build-task "Task 5" true)]))]))
  (def tasks (report plan (d/date 2020 8 7) 2))
  (test (length tasks) 3)
  (test ((tasks 0) :title) "Task 2")
  (test ((tasks 1) :title) "Task 3")
  (test ((tasks 2) :title) "Task 4"))

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test build-command

(deftest "doesn't build the command when arguments are not matching"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "builds the command when arguments are matching"
  (def arguments {"report" "7"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))

(deftest "returns error when arguments are not correct"
  (def arguments {"report" "seven"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--report argument is not a number."))
