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
  (def inbox (plan :inbox))
  (is (= "Main TODO" (plan :title)))
  (is (= {:title "Fix the lamp" :done false} (inbox 0)))
  (is (= {:title "Update Rust" :done false} (inbox 1))))

(run-tests!)
