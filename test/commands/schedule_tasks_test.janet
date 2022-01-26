(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_tasks :prefix "")

## -----------------------------------------------------------------------------
## Test schedule-tasks

(def plan (plan/build-plan "My Plan" @[]
                           @[(day/build-day (d/date 2022 1 18))
                             (day/build-day (d/date 2022 1 17))]))

(deftest schedule-task-on-specific-weekday
  (def scheduled-tasks
    @[(task/build-scheduled-task "Weekly meeting" "every Monday")])
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (is (empty? (((plan :days) 0) :tasks)))
  (is (= {:title "Weekly meeting" :done false :schedule "every Monday"}
         ((((plan :days) 1) :tasks) 0))))

(run-tests!)
