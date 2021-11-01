(import testament :prefix "" :exit true)
(import ../src/date :prefix "")
(import ../src/entities :as "e")
(import ../src/string_repository :as "repo")
(import ../src/file_repository)

(def todo
  ```
  # Main TODO

  ## Inbox

  - [ ] Fix the lamp

  ## 2020-08-01, Saturday

  - [ ] Develop photos
  - [x] Pay bills

  ## 2020-07-31, Friday

  - [x] Review open pull requests
  - [x] Fix the flaky test
  ```)

(deftest load-string-into-entities
  (def days (repo/load todo))
  (def day-1 (days 0))
  (def day-2 (days 1))
  (is (= 2 (length days)))
  (is (= (date 2020 8 1) (day-1 :date)))
  (is (= false (day-1 :changed)))
  (is (= (date 2020 7 31) (day-2 :date)))
  (is (= false (day-2 :changed))))

(deftest load-tasks-from-string-into-entities
  (def days (repo/load todo))
  (def day-1 (days 0))
  (def day-2 (days 1))
  (def tasks-1 (day-1 :tasks))
  (def tasks-2 (day-2 :tasks))
  (is (= 2 (length tasks-1)))
  (is (= "Develop photos" ((tasks-1 0) :title)))
  (is (not ((tasks-1 0) :done)))
  (is ((tasks-1 1) :done))
  (is (= "Pay bills" ((tasks-1 1) :title)))
  (is (= 2 (length tasks-2)))
  (is (= "Review open pull requests" ((tasks-2 0) :title)))
  (is (= "Fix the flaky test" ((tasks-2 1) :title)))
  (is ((tasks-2 0) :done))
  (is ((tasks-2 1) :done)))

(deftest load-file-into-entities
  (def load-result (file_repository/load-todo "test/examples/todo.md"))
  (def days (repo/load (load-result :todo)))
  (is (= 2 (length days)))
  (is (= (date 2020 8 1) ((days 0) :date)))
  (is (= (date 2020 7 31) ((days 1) :date)))
  (is (= 2 (length ((days 0) :tasks))))
  (is (= 2 (length ((days 1) :tasks)))))

(deftest save-entities-into-string
  (def days @[(e/build-day (date 2020 8 3))
              (e/build-day (date 2020 8 2))])
  (def new-todo
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
  (is (= new-todo (repo/save days todo))))

(run-tests!)
