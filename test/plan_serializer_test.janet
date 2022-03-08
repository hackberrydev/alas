(import testament :prefix "" :exit true)
(import ../src/plan_serializer :prefix "")
(import ../src/date :as d)
(import ../src/day)
(import ../src/event)
(import ../src/plan)
(import ../src/task)

(deftest serialize-plan
  (def plan
    (plan/build-plan
      :title "Main TODO"
      :inbox @[(task/build-task "Fix the lamp" false)]
      :days @[(day/build-day (d/date 2020 8 3))
              (day/build-day (d/date 2020 8 2))
              (day/build-day (d/date 2020 8 1)
                             @[(event/build-event "Talked to Mike")]
                             @[(task/build-task "Develop photos" false)
                               (task/build-task "Pay bills" true)])
              (day/build-day (d/date 2020 7 31)
                             @[]
                             @[(task/build-task "Review open pull requests" true)
                               (task/build-task "Fix the flaky test" true)])]))
  (def plan-string
       ```
       # Main TODO

       ## Inbox

       - [ ] Fix the lamp

       ## 2020-08-03, Monday

       ## 2020-08-02, Sunday

       ## 2020-08-01, Saturday

       - Talked to Mike
       - [ ] Develop photos
       - [X] Pay bills

       ## 2020-07-31, Friday

       - [X] Review open pull requests
       - [X] Fix the flaky test

      ```)
  (is (= plan-string (serialize plan))))

(deftest serialize-plan-with-empty-inbox
  (def plan
    (plan/build-plan :title "My Plan"
                     :days @[(day/build-day (d/date 2020 8 1))]))
  (def plan-string
    ```
    # My Plan

    ## Inbox

    ## 2020-08-01, Saturday

    ```)
  (is (= plan-string (serialize plan {:serialize-empty-inbox true}))))

(deftest serialize-plan-without-inbox
  (def plan
    (plan/build-plan :title "My Plan"
                     :days @[(day/build-day (d/date 2020 8 1))]))
  (def plan-string
    ```
    # My Plan

    ## 2020-08-01, Saturday

    ```)
  (is (= plan-string (serialize plan))))

(run-tests!)
