(use judge)

(import ../src/date :as d)
(import ../src/schedule_parser)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse-schedule

(deftest "parses the schedule"
  (def schedule-string
    ```
    # Scheduled Tasks

    - Weekly Meeting (every Tuesday)
    - Puzzle Storm on Lichess (every day)
    - Deploy the web app (every weekday)
    - Pay football practice (every month)
    - Martha's birthday (every 05-24)
    - Meeting with Jack (on 2022-05-03)
    - Review logs (every last day)
    ```)
  (def result (schedule_parser/parse schedule-string))
  (def scheduled-tasks (result :tasks))
  (test (length scheduled-tasks) 7)
  (let [task (scheduled-tasks 0)]
    (test (task :title) "Weekly Meeting")
    (test (task :done) false)
    (test (task :schedule) "every Tuesday"))
  (let [task (scheduled-tasks 1)]
    (test (task :title) "Puzzle Storm on Lichess")
    (test (task :schedule) "every day"))
  (let [task (scheduled-tasks 5)]
    (test (task :title) "Meeting with Jack")
    (test (task :schedule) "on 2022-05-03"))
  (let [task (scheduled-tasks 6)]
    (test (task :title) "Review logs")
    (test (task :schedule) "every last day")))

(deftest "returns an error when the schedule can't be parsed"
  (def schedule-string
    ```
    ## Schedule

    * One (always)
    ```)
  (def result (schedule_parser/parse schedule-string))
  (test (first (result :errors)) "Schedule can not be parsed"))

(deftest "returns an error when the schedule can be partially parsed"
  (def schedule-string
    ```
    # Scheduled Tasks

    - Weekly Meeting (every Tuesday)
    - Puzzle Storm on Lichess
    - Deploy the web app (every weekday)
    ```)
  (def result (schedule_parser/parse schedule-string))
  (test (first (result :errors))
        "Schedule can not be parsed - last parsed task is \"Weekly Meeting\" on line 3"))


(deftest "returns an error when the schedule is empty"
  (def schedule-string
    ```
    # Scheduled Tasks
    ```)
  (def result (schedule_parser/parse schedule-string))
  (test (first (result :errors)) "Schedule is empty"))
