(import testament :prefix "" :exit true)
(import ../src/file_repository :prefix "")

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test save

(deftest save
  (def new-plan-path "test/examples/new_plan.md")
  (def plan

       ```
       # Main TODO

       ## Inbox

       - [ ] Fix the lamp

       ## 2020-08-03, Monday

       ## 2020-08-02, Sunday

       ## 2020-08-01, Saturday

       - [ ] Develop photos
       - [x] Pay bills

       ## 2020-07-31, Friday

       - [x] Review open pull requests
       - [x] Fix the flaky test
      ```)
  (save plan new-plan-path)
  (is (= plan ((load new-plan-path) :text)))
  (os/rm new-plan-path))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test load

(deftest load-from-file
  (let [result (load "test/examples/todo.md")
        text (result :text)]
    (is (= 14 (length (string/split "\n" text))))))

(deftest load-from-file-that-does-not-exist
  (let [result (load "missing_file.md")]
    (is (= "File does not exist" (first (result :errors))))))

(run-tests!)
