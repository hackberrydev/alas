(import testament :prefix "" :exit true)
(import ../src/plan_parser :prefix "")

(deftest parse-plan
  (def plan-string
    ```
    # Main TODO

    ## Inbox

    - [ ] Fix the lamp
    - [ ] Update Rust

    ## 2020-08-01, Saturday

    - [ ] Develop photos
    - [x] Pay bills

    ## 2020-07-31, Friday

    - [x] Review open pull requests
    - [x] Fix the flaky test
    ```)
  (def plan (first (parse plan-string)))
  (is (= (plan :title) "Main TODO")))

(run-tests!)
