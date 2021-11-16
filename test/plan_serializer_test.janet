(import testament :prefix "" :exit true)
(import ../src/date :prefix "")
(import ../src/entities :as "e")
(import ../src/string_repository :as "repo")
(import ../src/file_repository)

(def todo-string
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
  (is (= new-todo (repo/save days todo-string))))

(run-tests!)
