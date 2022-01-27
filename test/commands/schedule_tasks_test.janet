(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_tasks :prefix "")

## -----------------------------------------------------------------------------
## Test scheduled-for?

(deftest scheduled-for-monday
  (def task (task/build-scheduled-task "Weekly meeting" "every Monday"))
  (is (scheduled-for? task (d/date 2022 1 24)))
  (is (not (scheduled-for? task (d/date 2022 1 25)))))

(deftest scheduled-for-tuesday
  (def task (task/build-scheduled-task "Weekly meeting" "every Tuesday"))
  (is (not (scheduled-for? task (d/date 2022 1 24))))
  (is (scheduled-for? task (d/date 2022 1 25))))

(deftest scheduled-for-every-month
  (def task (task/build-scheduled-task "Review logs" "every month"))
  (is (scheduled-for? task (d/date 2022 1 1)))
  (is (not (scheduled-for? task (d/date 2022 1 2))))
  (is (scheduled-for? task (d/date 2022 6 1)))
  (is (not (scheduled-for? task (d/date 2022 6 15)))))

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
