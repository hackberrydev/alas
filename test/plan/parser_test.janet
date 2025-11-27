(use judge)

(import ../../src/plan/parser :prefix "")
(import ../../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse

(deftest "parses a plan string"
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
    - [X] #work - Review open pull requests
    - [~] #work - Review logs
    - [x] #work - Fix the flaky test
    ```)
  (def parse-result (parse plan-string))
  (def plan (parse-result :plan))
  (def inbox (plan :inbox))
  (def day-1 ((plan :days) 0))
  (def day-2 ((plan :days) 1))
  (test (plan :title) "Main TODO")
  (let [task (inbox 0)]
    (test (task :title) "#home - Fix the lamp")
    (test (task :state) :open))
  (let [task (inbox 1)]
    (test (task :title) "Update Rust")
    (test (task :state) :open))
  (test (= (d/date 2020 8 1) (day-1 :date)) true)
  (let [task ((day-1 :tasks) 0)]
    (test (task :title) "Develop photos")
    (test (task :state) :open))
  (let [task ((day-1 :tasks) 1)]
    (test (task :title) "Pay bills")
    (test (task :state) :checked))
  (let [task ((day-1 :tasks) 2)]
    (test (task :title) "Fix the lamp")
    (test (task :state) :open)
    (test (d/equal? (d/date 2020 7 30) (task :missed-on)) true))
  (test (= (d/date 2020 7 31) (day-2 :date)) true)
  (let [event ((day-2 :events) 0)]
    (test (event :title) "Talked to Mike & Molly")
    (test (empty? (event :body)) true))
  (let [task ((day-2 :tasks) 0)]
    (test (task :title) "#work - Review open pull requests")
    (test (task :state) :checked))
  (let [task ((day-2 :tasks) 1)]
    (test (task :title) "#work - Review logs")
    (test (task :state) :obsolete))
  (let [task ((day-2 :tasks) 2)]
    (test (task :title) "#work - Fix the flaky test")
    (test (task :state) :checked)))

(deftest "parses a template plan"
  (def plan-string
    ```
    # Main TODO

    ## Inbox

    ## 2022-05-12, Thursday
    ```)
  (def plan ((parse plan-string) :plan))
  (test  (length (plan :days)) 1)
  (test (= (d/date 2022 5 12) (((plan :days) 0) :date)) true))

(deftest "parses a plan with one task"
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
    ```)
  (def plan ((parse plan-string) :plan))
  (test  (length (plan :days)) 1)
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (test (= (d/date 2020 7 30) (day :date)) true)
    (test (task :title) "Pay bills")
    (test (task :state) :open)))

(deftest "parses a plan with one task that has a body"
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
      - Electricity
      - Water
    ```)
  (def plan ((parse plan-string) :plan))
  (test  (length (plan :days)) 1)
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)
        task-body (task :body)]
    (test (= (d/date 2020 7 30) (day :date)) true)
    (test (task :title) "Pay bills")
    (test (task :state) :open)
    (test (task-body 0) "- Electricity")
    (test (task-body 1) "- Water")))

(deftest "parses a plan with 2 tasks"
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - [ ] Pay bills
    - [x] Fix the lamp
    ```)
  (def plan ((parse plan-string) :plan))
  (test  (length (plan :days)) 1)
  (let [day ((plan :days) 0)
        task-1 ((day :tasks) 0)
        task-2 ((day :tasks) 1)]
    (test (= (d/date 2020 7 30) (day :date)) true)
    (test (task-1 :title) "Pay bills")
    (test (task-1 :state) :open)
    (test (task-2 :title) "Fix the lamp")
    (test (task-2 :state) :checked)))

(deftest "parses a plan without inbox"
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
  (test (plan :title) "Main TODO")
  (test (empty? (plan :inbox)) true)
  (test (= (d/date 2020 8 1) (day-1 :date)) true)
  (test (= (d/date 2020 7 31) (day-2 :date)) true))

(deftest "parses a plan with empty inbox"
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
  (test (plan :title) "Main TODO")
  (test (empty? (plan :inbox)) true)
  (test (= (d/date 2020 8 1) (day-1 :date)) true)
  (test (= (d/date 2020 7 31) (day-2 :date)) true))

(deftest "parses a plan with an event that has a body"
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - Talked to Mike & Molly
      - They moved to a new apartment
    - [x] Fix the lamp
    ```)
  (def parse-result (parse plan-string))
  (def plan (parse-result :plan))
  (test  (length (plan :days)) 1)
  (let [day ((plan :days) 0)
        event ((day :events) 0)
        task ((day :tasks) 0)]
    (test (= (d/date 2020 7 30) (day :date)) true)
    (test (event :title) "Talked to Mike & Molly")
    (test ((event :body) 0) "- They moved to a new apartment")
    (test (task :title) "Fix the lamp")
    (test (task :state) :checked)))

(deftest "parses a plan with an event without any tasks"
  (def plan-string
    ```
    # Main TODO

    ## 2020-07-30, Thursday

    - Talked to Mike & Molly
    ```)
  (def plan ((parse plan-string) :plan))
  (test  (length (plan :days)) 1)
  (let [day ((plan :days) 0)
        event ((day :events) 0)]
    (test (event :title) "Talked to Mike & Molly")))

(deftest "returns an error when the plan can't be parsed"
  (def plan-string
    ```
    ## Main TODO

    - [ ] Pay bills
    - [O] Talk to Mike
    ```)
  (def parse-result (parse plan-string))
  (test (parse-result :errors)
        ["Plan can not be parsed"]))

(deftest "returns an error when the plan can be partially parsed"
  (def plan-string
    ```
    # Main TODO

    ## 2020-01-31, Friday

    ## 2020-01-30, Thursday

    ## Tomorrow
    ```)
  (def parse-result (parse plan-string))
  (test (parse-result :errors)
        ["Plan can not be parsed: last parsed line is line 6"]))
