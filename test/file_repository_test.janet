(import testament :prefix "" :exit true)
(import ../src/file_repository :as "file-repository")

(deftest load-plan-from-file
  (let [result (file-repository/load-plan "test/examples/todo.md")
        plan (result :plan)]
    (is (= 14 (length (string/split "\n" plan))))))

(deftest load-plan-from-file-that-does-not-exist
  (let [result (file-repository/load-plan "missing_file.md")]
    (is (= "File does not exist" (result :error)))))

(deftest save-plan
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
  (file-repository/save-plan plan new-plan-path)
  (is (= plan ((file-repository/load-plan new-plan-path) :plan)))
  (os/rm new-plan-path))

(run-tests!)
