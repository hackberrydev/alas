(import testament :prefix "" :exit true)

(import ../../src/plan/parser :prefix "")
(import ../../src/date :as d)

## ————————————————————————————————————————————————————————————————————————————————————————————————
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
    - [ ] Fix the lamp (missed on 2020-07-30)

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
  (let [task (inbox 0)]
    (is (= "#home - Fix the lamp" (task :title)))
    (is (not (task :done))))
  (let [task (inbox 1)]
    (is (= "Update Rust" (task :title)))
    (is (not (task :done))))
  (is (= (d/date 2020 8 1) (day-1 :date)))
  (let [task ((day-1 :tasks) 0)]
    (is (= "Develop photos" (task :title)))
    (is (not (task :done))))
  (let [task ((day-1 :tasks) 1)]
    (is (= "Pay bills" (task :title)))
    (is (task :done)))
  (let [task ((day-1 :tasks) 2)]
    (is (= "Fix the lamp" (task :title)))
    (is (not (task :done)))
    (is (d/equal? (d/date 2020 7 30) (task :missed-on))))
  (is (= (d/date 2020 7 31) (day-2 :date)))
  (is (= {:text "Talked to Mike & Molly"} ((day-2 :events) 0)))
  (let [task ((day-2 :tasks) 0)]
    (is (= "#work - Review open pull requests" (task :title)))
    (is (task :done)))
  (let [task ((day-2 :tasks) 1)]
    (is (= "#work - Fix the flaky test" (task :title)))
    (is (task :done))))

(deftest parse-template-plan
  (def plan-string
    ```
    # Main TODO

    ## Inbox

    ## 2022-05-12, Thursday
    ```)
  (def plan ((parse plan-string) :plan))
  (is (= 1 (length (plan :days))))
  (is (= (d/date 2022 5 12) (((plan :days) 0) :date))))

(deftest parse-plan-with-one-task
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
    ```)
  (def plan ((parse plan-string) :plan))
  (is (= 1 (length (plan :days))))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (is (= (d/date 2020 7 30) (day :date)))
    (is (= "Pay bills" (task :title)))
    (is (not (task :done)))))

(deftest parse-plan-with-one-task-with-body
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
      - Electricity
      - Water
    ```)
  (def plan ((parse plan-string) :plan))
  (is (= 1 (length (plan :days))))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)
        task-body (task :body)]
    (is (= (d/date 2020 7 30) (day :date)))
    (is (= "Pay bills" (task :title)))
    (is (not (task :done)))
    (is (= "- Electricity" (task-body 0)))
    (is (= "- Water" (task-body 1)))))

(deftest parse-plan-with-two-tasks
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
    - [x] Fix the lamp
    ```)
  (def plan ((parse plan-string) :plan))
  (is (= 1 (length (plan :days))))
  (let [day ((plan :days) 0)
        task-1 ((day :tasks) 0)
        task-2 ((day :tasks) 1)]
    (is (= (d/date 2020 7 30) (day :date)))
    (is (= "Pay bills" (task-1 :title)))
    (is (not (task-1 :done)))
    (is (= "Fix the lamp" (task-2 :title)))
    (is (task-2 :done))))

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

(deftest parse-plan-with-empty-inbox
  (def plan-string
    ```
    # Main TODO

    ## Inbox

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
  (is (parse-result :errors))
  (is (= "Plan can not be parsed" (first (parse-result :errors)))))

(deftest parse-when-plan-can-partially-be-parsed
  (def plan-string
    ```
    # Main TODO

    ## 2020-01-31, Friday

    ## 2020-01-30, Thursday

    ## Tomorrow
    ```)
  (def parse-result (parse plan-string))
  (is (parse-result :errors))
  (is (= "Plan can not be parsed: last parsed line is line 6"
         (first (parse-result :errors)))))

(run-tests!)
