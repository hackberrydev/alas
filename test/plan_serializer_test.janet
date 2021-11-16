(import testament :prefix "" :exit true)
(import ../src/plan_serializer :prefix "")
(import ../src/date :as d)
(import ../src/entities :as e)

(deftest serialize-plan
  (def plan
    (e/build-plan "Main TODO"
                  @[(e/build-task "Fix the lamp" false)]
                  @[(e/build-day (d/date 2020 8 3))
                    (e/build-day (d/date 2020 8 2))
                    (e/build-day (d/date 2020 8 1)
                                 @[(e/build-task "Develop photos" false)
                                   (e/build-task "Pay bills" true)])
                    (e/build-day (d/date 2020 7 31)
                                 @[(e/build-task "Review open pull requests" true)
                                   (e/build-task "Fix the flaky test" true)])]))
  (def plan-string
       ```
       # Main TODO

       ## Inbox

       - [ ] Fix the lamp

       ## 2020-08-03, Monday


       ## 2020-08-02, Sunday


       ## 2020-08-01, Saturday

       - [ ] Develop photos
       - [X] Pay bills

       ## 2020-07-31, Friday

       - [X] Review open pull requests
       - [X] Fix the flaky test
      ```)
  (is (= plan-string (serialize plan))))

(run-tests!)
