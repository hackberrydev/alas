(use judge)

(import ../src/file_repository :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test save

(deftest "saves plan to a file"
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
  (test (= ((load new-plan-path) :text) plan) true)
  (os/rm new-plan-path))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test load

(deftest "loads a plan from a file to a string"
  (let [result (load "test/examples/todo.md")
        text (result :text)]
    (test (length (string/split "\n" text)) 14)))

(deftest "returns an error when the file doesn't exist"
  (def result (load "missing_file.md"))
  (test (first (result :errors)) "File does not exist"))
