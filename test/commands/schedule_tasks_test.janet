(import testament :prefix "" :exit true)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_tasks :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
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

(deftest scheduled-for-every-3-months
  (def task (task/build-scheduled-task "Review logs" "every 3 months"))
  (is (scheduled-for? task (d/date 2022 1 1)))
  (is (not (scheduled-for? task (d/date 2022 2 1))))
  (is (not (scheduled-for? task (d/date 2022 3 1))))
  (is (scheduled-for? task (d/date 2022 4 1)))
  (is (not (scheduled-for? task (d/date 2022 5 1))))
  (is (not (scheduled-for? task (d/date 2022 6 1))))
  (is (scheduled-for? task (d/date 2022 7 1)))
  (is (not (scheduled-for? task (d/date 2022 8 1))))
  (is (not (scheduled-for? task (d/date 2022 9 1))))
  (is (scheduled-for? task (d/date 2022 10 1))))

(deftest scheduled-for-every-weekday
  (def task (task/build-scheduled-task "Review logs" "every weekday"))
  (is (scheduled-for? task (d/date 2022 1 24)))        # Monday
  (is (scheduled-for? task (d/date 2022 1 25)))        # Tuesday
  (is (scheduled-for? task (d/date 2022 1 26)))        # Wednesday
  (is (scheduled-for? task (d/date 2022 1 27)))        # Thursday
  (is (scheduled-for? task (d/date 2022 1 28)))        # Friday
  (is (not (scheduled-for? task (d/date 2022 1 29))))  # Saturday
  (is (not (scheduled-for? task (d/date 2022 1 30))))) # Sunday

(deftest scheduled-for-specific-date-every-year
  (def task (task/build-scheduled-task "Review logs" "every year on 01-27"))
  (is (scheduled-for? task (d/date 2022 1 27)))
  (is (scheduled-for? task (d/date 2023 1 27)))
  (is (scheduled-for? task (d/date 2024 1 27)))
  (is (not (scheduled-for? task (d/date 2022 1 26))))
  (is (not (scheduled-for? task (d/date 2022 1 28))))
  (is (not (scheduled-for? task (d/date 2022 2 1)))))

(deftest scheduled-for-specific-date
  (def task (task/build-scheduled-task "Review logs" "on 2022-01-27"))
  (is (scheduled-for? task (d/date 2022 1 27)))
  (is (not (scheduled-for? task (d/date 2022 1 26))))
  (is (not (scheduled-for? task (d/date 2022 1 28))))
  (is (not (scheduled-for? task (d/date 2022 2 1))))
  (is (not (scheduled-for? task (d/date 2023 1 27)))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test missed?

(def scheduled-task (task/build-scheduled-task "Weekly meeting" "on 2022-08-01"))

(deftest missed-returns-true-when-task-is-missed
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 8 2))
                      (day/build-day (d/date 2022 8 1))]))
  (is (missed? plan scheduled-task)))

(deftest missed-returns-false-when-task-was-scheduled-for-another-day
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 8 2)
                                     @[]
                                     @[task/build-task "Weekly meeting" true])
                      (day/build-day (d/date 2022 8 1))]))
  (is (not (missed? plan scheduled-task))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test schedule-tasks

(def scheduled-tasks
  @[(task/build-scheduled-task "Weekly meeting" "every Monday")])

(deftest schedule-task-on-specific-weekday
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (is (empty? (((plan :days) 0) :tasks)))
  (let [day ((plan :days) 1)
        task ((day :tasks) 0)]
    (is (= "Weekly meeting" (task :title)))
    (is (= false (task :done)))
    (is (= "every Monday" (task :schedule)))))

(deftest schedule-tasks-does-not-insert-duplicate-tasks
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (is (empty? (((plan :days) 0) :tasks)))
  (is (= 1 (length (((plan :days) 1) :tasks)))))

(deftest schedule-missed-task
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 18))
  (is (empty? (((plan :days) 1) :tasks)))
  (let [day ((plan :days) 0)]
    (is (not (empty? (day :tasks))))
    (if (not (empty? (day :tasks)))
      (let [task ((day :tasks) 0)]
        (is (= "Weekly meeting" (task :title)))
        (is (= false (task :done)))
        (is (= "every Monday" (task :schedule)))))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest build-command-without-matching-argument
  (def arguments {"stats" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"schedule-tasks" "test/examples/schedule.md"})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(deftest build-command-when-schedule-does-not-exist
  (def arguments {"schedule-tasks" "test/examples/missing-schedule.md"})
  (def result (build-command arguments))
  (is (nil? (result :command)))
  (is (= "--schedule-tasks file does not exist." (first (result :errors)))))

(deftest build-command-when-schedule-can-not-be-parsed
  (def arguments {"schedule-tasks" "test/examples/unparsable-schedule.md"})
  (def result (build-command arguments))
  (is (nil? (result :command)))
  (is (= "--schedule-tasks schedule could not be parsed." (first (result :errors)))))

(deftest build-command-when-schedule-is-empty
  (def arguments {"schedule-tasks" "test/examples/empty-schedule.md"})
  (def result (build-command arguments))
  (is (nil? (result :command)))
  (is (= "--schedule-tasks schedule is empty." (first (result :errors)))))

(run-tests!)
