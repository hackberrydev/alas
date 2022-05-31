(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/schedule_parser)

(deftest parse-schedule
  (def schedule-string
    ```
    # Scheduled Tasks

    - Weekly Meeting (every Tuesday)
    - Puzzle Storm on Lichess (every day)
    - Deploy the web app (every weekday)
    - Pay football practice (every month)
    - Martha's birthsday (every 05-24)
    - Meeting with Jack (on 2022-05-03)
    ```)
  (def scheduled-tasks (first (schedule_parser/parse schedule-string)))
  (is (= 6 (length scheduled-tasks)))
  (let [task (scheduled-tasks 0)]
    (is (= "Weekly Meeting" (task :title)))
    (is (= false (task :done)))
    (is (= "every Tuesday" (task :schedule))))
  (let [task (scheduled-tasks 1)]
    (is (= "Puzzle Storm on Lichess" (task :title)))
    (is (= false (task :done)))
    (is (= "every day" (task :schedule))))
  (let [task (scheduled-tasks 5)]
    (is (= "Meeting with Jack" (task :title)))
    (is (= false (task :done)))
    (is (= "on 2022-05-03" (task :schedule)))))

(run-tests!)
