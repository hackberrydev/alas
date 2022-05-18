(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/day)
(import ../../src/plan)
(import ../../src/task)
(import ../../src/commands/insert_task :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test insert-task

(deftest insert-task-when-day-exists-and-task-does-not-exist
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 10))]))
  (def new-plan (insert-task plan (d/date 2020 8 10) "Upgrade OS"))
  (def day (first (new-plan :days)))
  (is (= 1 (length (day :tasks))))
  (is (= "Upgrade OS" ((first (day :tasks)) :title))))

(deftest insert-task-when-day-does-not-exist
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2020 8 10))]))
  (def new-plan (insert-task plan (d/date 2020 8 11) "Upgrade OS"))
  (is (= 1 (length (plan :days))))
  (is (empty? ((first (plan :days)) :tasks))))

(deftest insert-taks-when-task-already-exists
  (def day (day/build-day (d/date 2020 8 10)
                          @[]
                          @[(task/build-task "Upgrade OS" false)]))
  (def plan (plan/build-plan :days @[day]))
  (def new-plan (insert-task plan (d/date 2020 8 10) "Upgrade OS"))
  (def new-day (first (new-plan :days)))
  (is (= 1 (length (new-day :tasks))))
  (is (= "Upgrade OS" ((first (new-day :tasks)) :title))))

(run-tests!)
