(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/plan_parser :prefix "")

## -----------------------------------------------------------------------------
## Test parse

(deftest parse-plan
  (def plan-string
    ```
    # Main TODO

    ## Inbox

    - [ ] #home - Fix the lamp
    - [ ] Update Rust

    ## 2020-08-01, Saturday

    - [ ] Develop photos
    - [x] Pay bills

    ## 2020-07-31, Friday

    - Talked to Mike & Molly
    - [x] #work - Review open pull requests
    - [x] #work - Fix the flaky test
    ```)
  (def plan ((parse plan-string) :plan))
  (def inbox (plan :inbox))
  (def day-1 ((plan :days) 0))
  (def day-2 ((plan :days) 1))
  (is (= "Main TODO" (plan :title)))
  (is (= {:title "#home - Fix the lamp" :done false} (inbox 0)))
  (is (= {:title "Update Rust" :done false} (inbox 1)))
  (is (= (d/date 2020 8 1) (day-1 :date)))
  (is (= {:title "Develop photos" :done false} ((day-1 :tasks) 0)))
  (is (= {:title "Pay bills" :done true} ((day-1 :tasks) 1)))
  (is (= (d/date 2020 7 31) (day-2 :date)))
  (is (= {:text "Talked to Mike & Molly"} ((day-2 :events) 0)))
  (is (= {:title "#work - Review open pull requests" :done true} ((day-2 :tasks) 0)))
  (is (= {:title "#work - Fix the flaky test" :done true} ((day-2 :tasks) 1))))

(deftest parse-plan-without-inbox
  (def plan-string
    ```
    # Main TODO

    ## 2020-08-01, Saturday

    - [ ] Develop photos
    - [x] Pay bills

    ## 2020-07-31, Friday

    - Talked to Mike & Molly
    - [x] #work - Review open pull requests
    - [x] #work - Fix the flaky test
    ```)
  (def plan ((parse plan-string) :plan))
  (def day-1 ((plan :days) 0))
  (def day-2 ((plan :days) 1))
  (is (= "Main TODO" (plan :title)))
  (is (empty? (plan :inbox)))
  (is (= (d/date 2020 8 1) (day-1 :date)))
  (is (= (d/date 2020 7 31) (day-2 :date))))

(deftest parse-when-plan-can-not-be-parsed
  (def plan-string
    ```
    ## Main TODO

    - [ ] Pay bills
    - [O] Talk to Mike
    ```)
  (def parse-result (parse plan-string))
  (is (parse-result :error))
  (is (= "Plan can not be parsed" (parse-result :error))))

(deftest parse-when-plan-can-partially-be-parsed
  (def plan-string
    ```
    # Main TODO

    ## Tomorrow

    - [ ] Pay bills
    ```)
  (def parse-result (parse plan-string))
  (is (parse-result :error))
  (is (= "Plan can not be parsed: last parsed line is line 1")
      (parse-result :error)))

(run-tests!)
