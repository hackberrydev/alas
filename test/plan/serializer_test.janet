(use judge)

(import ../../src/plan/serializer :prefix "")
(import ../../src/date :as d)
(import ../../src/day)
(import ../../src/event)
(import ../../src/plan)
(import ../../src/task)

(deftest "serializes a plan"
  (def plan
    (plan/build-plan
      :title "Main TODO"
      :inbox @[(task/build-task "Fix the lamp" :open)]
      :days @[(day/build-day (d/date 2020 8 3))
              (day/build-day (d/date 2020 8 2))
              (day/build-day (d/date 2020 8 1)
                             @[(event/build-event "Talked to Mike" @["- He has a new car"])]
                             @[(task/build-task "Develop photos" :open)
                               (task/build-task "Pay bills" :checked @["- Electricity" "- Water"])
                               (task/build-missed-task "Organize photos" (d/date 2020 7 20))])
              (day/build-day (d/date 2020 7 31)
                             @[]
                             @[(task/build-task "Review open pull requests" :checked)
                               (task/build-task "Fix the flaky test" :checked)])]))
  (def plan-string
       ```
       # Main TODO

       ## Inbox

       - [ ] Fix the lamp

       ## 2020-08-03, Monday

       ## 2020-08-02, Sunday

       ## 2020-08-01, Saturday

       - Talked to Mike
         - He has a new car
       - [ ] Develop photos
       - [X] Pay bills
         - Electricity
         - Water
       - [ ] Organize photos (missed on 2020-07-20)

       ## 2020-07-31, Friday

       - [X] Review open pull requests
       - [X] Fix the flaky test

      ```)
  (test (= (serialize plan) plan-string) true))

(deftest "serializes a plan with an empty inbox"
  (def plan
    (plan/build-plan :title "My Plan"
                     :days @[(day/build-day (d/date 2020 8 1))]))
  (def plan-string
    ```
    # My Plan

    ## Inbox

    ## 2020-08-01, Saturday

    ```)
  (test (= (serialize plan {:serialize-empty-inbox true}) plan-string) true))

(deftest "serializes a plan without an inbox"
  (def plan
    (plan/build-plan :title "My Plan"
                     :days @[(day/build-day (d/date 2020 8 1))]))
  (def plan-string
    ```
    # My Plan

    ## 2020-08-01, Saturday

    ```)
  (test (= (serialize plan) plan-string) true))
