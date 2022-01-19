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
  (is (= {:title "Weekly Meeting" :done false :schedule "every Tuesday"}
         (scheduled-tasks 0)))
  (is (= {:title "Puzzle Storm on Lichess" :done false :schedule "every day"}
         (scheduled-tasks 1))))

(run-tests!)
