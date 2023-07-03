(use judge)

(import ../../src/date :as "d")
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_tasks :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test scheduled-for?

(deftest "every Monday"
  (def task (task/build-scheduled-task "Weekly meeting" "every Monday"))
  (test (scheduled-for? task (d/date 2022 1 24)) true)
  (test (not (scheduled-for? task (d/date 2022 1 25))) true))

(deftest "every Tuesday"
  (def task (task/build-scheduled-task "Weekly meeting" "every Tuesday"))
  (test (not (scheduled-for? task (d/date 2022 1 24))) true)
  (test (scheduled-for? task (d/date 2022 1 25)) true))

(deftest "every month"
  (def task (task/build-scheduled-task "Review logs" "every month"))
  (test (scheduled-for? task (d/date 2022 1 1)) true)
  (test (not (scheduled-for? task (d/date 2022 1 2))) true)
  (test (scheduled-for? task (d/date 2022 6 1)) true)
  (test (not (scheduled-for? task (d/date 2022 6 15))) true))

(deftest "every 3 months"
  (def task (task/build-scheduled-task "Review logs" "every 3 months"))
  (test (scheduled-for? task (d/date 2022 1 1)) true)
  (test (not (scheduled-for? task (d/date 2022 2 1))) true)
  (test (not (scheduled-for? task (d/date 2022 3 1))) true)
  (test (scheduled-for? task (d/date 2022 4 1)) true)
  (test (not (scheduled-for? task (d/date 2022 5 1))) true)
  (test (not (scheduled-for? task (d/date 2022 6 1))) true)
  (test (scheduled-for? task (d/date 2022 7 1)) true)
  (test (not (scheduled-for? task (d/date 2022 8 1))) true)
  (test (not (scheduled-for? task (d/date 2022 9 1))) true)
  (test (scheduled-for? task (d/date 2022 10 1)) true))

(deftest "every weekday"
  (def task (task/build-scheduled-task "Review logs" "every weekday"))
  (test (scheduled-for? task (d/date 2022 1 24)) true)        # Monday
  (test (scheduled-for? task (d/date 2022 1 25)) true)        # Tuesday
  (test (scheduled-for? task (d/date 2022 1 26)) true)        # Wednesday
  (test (scheduled-for? task (d/date 2022 1 27)) true)        # Thursday
  (test (scheduled-for? task (d/date 2022 1 28)) true)        # Friday
  (test (not (scheduled-for? task (d/date 2022 1 29))) true)  # Saturday
  (test (not (scheduled-for? task (d/date 2022 1 30))) true)) # Sunday

(deftest "every year on some date"
  (def task (task/build-scheduled-task "Review logs" "every year on 01-27"))
  (test (scheduled-for? task (d/date 2022 1 27)) true)
  (test (scheduled-for? task (d/date 2023 1 27)) true)
  (test (scheduled-for? task (d/date 2024 1 27)) true)
  (test (not (scheduled-for? task (d/date 2022 1 26))) true)
  (test (not (scheduled-for? task (d/date 2022 1 28))) true)
  (test (not (scheduled-for? task (d/date 2022 2 1))) true))

(deftest "on some date"
  (def task (task/build-scheduled-task "Review logs" "on 2022-01-27"))
  (test (scheduled-for? task (d/date 2022 1 27)) true)
  (test (not (scheduled-for? task (d/date 2022 1 26))) true)
  (test (not (scheduled-for? task (d/date 2022 1 28))) true)
  (test (not (scheduled-for? task (d/date 2022 2 1))) true)
  (test (not (scheduled-for? task (d/date 2023 1 27))) true))

(deftest "every last day"
  (def task (task/build-scheduled-task "Review logs" "every last day"))
  (test (scheduled-for? task (d/date 2022 1 31)) true)
  (test (scheduled-for? task (d/date 2022 2 28)) true)
  (test (scheduled-for? task (d/date 2022 3 31)) true)
  (test (scheduled-for? task (d/date 2022 4 30)) true)
  (test (scheduled-for? task (d/date 2022 5 31)) true)
  (test (scheduled-for? task (d/date 2022 6 30)) true)
  (test (scheduled-for? task (d/date 2022 7 31)) true)
  (test (scheduled-for? task (d/date 2022 8 31)) true)
  (test (scheduled-for? task (d/date 2022 9 30)) true)
  (test (scheduled-for? task (d/date 2022 10 31)) true)
  (test (scheduled-for? task (d/date 2022 11 30)) true)
  (test (scheduled-for? task (d/date 2022 12 31)) true)
  (test (scheduled-for? task (d/date 2023 1 31)) true)
  (test (not (scheduled-for? task (d/date 2022 1 30))) true))

(deftest "every last Friday"
  (def task (task/build-scheduled-task "Review logs" "every last Friday"))
  (test (scheduled-for? task (d/date 2022 1 28)) true)
  (test (scheduled-for? task (d/date 2022 2 25)) true)
  (test (scheduled-for? task (d/date 2022 3 25)) true)
  (test (scheduled-for? task (d/date 2022 4 29)) true)
  (test (scheduled-for? task (d/date 2022 5 27)) true)
  (test (not (scheduled-for? task (d/date 2022 1 31))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test missed?

(def scheduled-task (task/build-scheduled-task "Weekly meeting" "on 2022-08-01"))

(deftest "returns true when the task is missed"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 8 2))
                      (day/build-day (d/date 2022 8 1))]))
  (test (missed? plan scheduled-task (d/date 2022 8 3)) true))

(deftest "returns true when the task is missed and the day doesn't exist"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 8 2))
                      (day/build-day (d/date 2022 7 15))]))
  (test (missed? plan scheduled-task (d/date 2022 8 3)) true))

(deftest "returns false when the task is scheduled for another day"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 8 2)
                                     @[]
                                     @[(task/build-task "Weekly meeting" true)])
                      (day/build-day (d/date 2022 8 1))]))
  (test (not (missed? plan scheduled-task (d/date 2022 8 3))) true))

(deftest "returns false when the task will be scheduled in future"
  (def plan (plan/build-plan
             :days @[(day/build-day (d/date 2022 8 2))
                     (day/build-day (d/date 2022 7 31))]))
  (test (not (missed? plan scheduled-task (d/date 2022 7 31))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test schedule-tasks

(def scheduled-tasks
  @[(task/build-scheduled-task "Weekly meeting" "every Monday")
    (task/build-scheduled-task "Check logs" "every Wednesday")])

(deftest "schedules tasks scheduled on specific weekdays"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (test (empty? (((plan :days) 0) :tasks)) true)
  (let [day ((plan :days) 1)
        task ((day :tasks) 0)]
    (test (task :title) "Weekly meeting")
    (test (task :done) false)
    (test (task :schedule) "every Monday")))

(deftest "doesn't insert duplicate tasks"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 17))
  (test (empty? (((plan :days) 0) :tasks)) true)
  (test (length (((plan :days) 1) :tasks)) 1))

(deftest "schedules missed tasks"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 18))
  (test (empty? (((plan :days) 1) :tasks)) true)
  (let [day ((plan :days) 0)]
    (test (not (empty? (day :tasks))) true)
    (if (not (empty? (day :tasks)))
      (let [task ((day :tasks) 0)]
        (test (task :title) "Weekly meeting")
        (test (d/equal? (d/date 2022 1 17) (task :missed-on)) true)
        (test (task :done) false)
        (test (task :schedule) "every Monday")))))

(deftest "schedules missed monthly tasks"
  (def scheduled-tasks
    @[(task/build-scheduled-task "Review logs" "every month")])
  (def day-1 (day/build-day (d/date 2022 7 5)))
  (def day-2 (day/build-day (d/date 2022 6 15)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 7 5))
  (test (not (empty? (day-1 :tasks))) true)
  (if (not (empty? (day-1 :tasks)))
    (test (((day-1 :tasks) 0) :title) "Review logs")))

(deftest "doesn't schedule tasks that are not yet scheduled for future"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 19))
                      (day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 17))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 18))
  (test (length (((plan :days) 0) :tasks)) 1)
  (test (length (((plan :days) 1) :tasks)) 1)
  (test (empty? (((plan :days) 2) :tasks)) true)
  (let [day ((plan :days) 1)]
    (if (not (empty? (day :tasks)))
      (let [task ((day :tasks) 0)]
        (test (task :title) "Weekly meeting")
        (test (task :done) false)
        (test (task :schedule) "every Monday")))))

(deftest "doesn't schedule tasks that are not scheduled for future day that is not in the plan"
  (def plan (plan/build-plan
              :days @[(day/build-day (d/date 2022 1 19))
                      (day/build-day (d/date 2022 1 18))
                      (day/build-day (d/date 2022 1 16))]))
  (schedule-tasks plan scheduled-tasks (d/date 2022 1 16))
  (test (length (((plan :days) 0) :tasks)) 1)
  (test (empty? (((plan :days) 1) :tasks)) true)
  (test (empty? (((plan :days) 2) :tasks)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "doesn't build the command when arguments are not matching"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "builds the command when arguments are matching"
  (def arguments {"schedule-tasks" "test/examples/schedule.md"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))

(deftest "returns an error when the schedule doesn't exist"
  (def arguments {"schedule-tasks" "test/examples/missing-schedule.md"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--schedule-tasks file does not exist."))

(deftest "returns an error when the schedule cannot be parsed"
  (def arguments {"schedule-tasks" "test/examples/unparsable-schedule.md"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--schedule-tasks schedule can not be parsed."))

(deftest "returns an error when the schedule is empty"
  (def arguments {"schedule-tasks" "test/examples/empty-schedule.md"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--schedule-tasks schedule is empty."))
