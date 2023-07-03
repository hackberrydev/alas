(use judge)

(import ../../src/date :as "d")
(import ../../src/day)
(import ../../src/plan)
(import ../../src/task)
(import ../../src/commands/insert_task :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test insert-task

(deftest "when the day exists and the task doesn't exist"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 10))]))
  (def new-plan (insert-task plan (d/date 2020 8 10) "Upgrade OS"))
  (def day (first (new-plan :days)))
  (test (length (day :tasks)) 1)
  (test ((first (day :tasks)) :title) "Upgrade OS"))

(deftest "when the day doesn't exist"
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 10))]))
  (def new-plan (insert-task plan (d/date 2020 8 11) "Upgrade OS"))
  (test (length (plan :days)) 1)
  (test (empty? ((first (plan :days)) :tasks)) true))

(deftest "when the task already exists"
  (def day (day/build-day (d/date 2020 8 10)
                          @[]
                          @[(task/build-task "Upgrade OS" false)]))
  (def plan (plan/build-plan :days @[day]))
  (def new-plan (insert-task plan (d/date 2020 8 10) "Upgrade OS"))
  (def new-day (first (new-plan :days)))
  (test (length (new-day :tasks)) 1)
  (test ((first (new-day :tasks)) :title) "Upgrade OS"))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "without matching arguments"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "with correct arguments"
  (def arguments {"insert-task" "Upgrade OS"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))
