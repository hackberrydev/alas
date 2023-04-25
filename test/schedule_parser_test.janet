(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/schedule_parser)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse-schedule

(deftest parse-schedule
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
  (is (= 7 (length scheduled-tasks)))
  (let [task (scheduled-tasks 0)]
    (is (= "Weekly Meeting" (task :title)))
    (is (= false (task :done)))
    (is (= "every Tuesday" (task :schedule))))
  (let [task (scheduled-tasks 1)]
    (is (= "Puzzle Storm on Lichess" (task :title)))
    (is (= "every day" (task :schedule))))
  (let [task (scheduled-tasks 5)]
    (is (= "Meeting with Jack" (task :title)))
    (is (= "on 2022-05-03" (task :schedule))))
  (let [task (scheduled-tasks 6)]
    (is (= "Review logs" (task :title)))
    (is (= "every last day" (task :schedule)))))

(deftest parse-schedule-when-schedule-can-not-be-parsed
  (def schedule-string
    ```
    ## Schedule

    * One (always)
    ```)
  (def result (schedule_parser/parse schedule-string))
  (is (= "Schedule can not be parsed" (first (result :errors)))))

(deftest parse-schedule-when-task-has-multiple-lines
  (def schedule-string
    ```
    # Scheduled Tasks

    - Weekly Meeting (every Tuesday)
    - Puzzle Storm on Lichess
    - Deploy the web app (every weekday)
    ```)
  (def result (schedule_parser/parse schedule-string))
  (is (= "Schedule can not be parsed - last parsed task is \"Weekly Meeting\""
         (first (result :errors)))))

(deftest parse-schedule-when-schedule-is-empty
  (def schedule-string
    ```
    # Scheduled Tasks
    ```)
  (def result (schedule_parser/parse schedule-string))
  (is (= "Schedule is empty" (first (result :errors)))))

(run-tests!)
