(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/report :prefix "")

## -----------------------------------------------------------------------------
## Test report

(deftest report
  (def plan
    (plan/build-plan "Plan" @[]
                     @[(day/build-day (d/date 2020 8 7) @[]
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
  (is (= 3 (length tasks)))
  (is (= "Task 2" ((tasks 0) :title)))
  (is (= "Task 3" ((tasks 1) :title)))
  (is (= "Task 4" ((tasks 2) :title))))

(run-tests!)
