(import testament :prefix "" :exit true)
(import ../src/date :prefix "")
(import ../src/entities :as "e")
(import ../src/string_repository :as "repo")

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
  (let [days (repo/load todo)]
    (is (= 2 (length days)))
    (is (= (date 2020 8 1) ((days 0) :date)))
    (is (= 6 ((days 0) :line-number)))
    (is (= false ((days 0) :changed)))
    (is (= (date 2020 7 31) ((days 1) :date)))
    (is (= 11 ((days 1) :line-number)))
    (is (= false ((days 1) :changed)))))

(deftest save-entities-into-string
  (def days @[(e/build-day (date 2020 8 3))
              (e/build-day (date 2020 8 2))])
  (is (= (repo/save days todo)
         ```
         # Main TODO

         ## Inbox

         - [ ] Fix the lamp

         ## 2020-08-02, Monday

         ## 2020-08-02, Sunday

         ## 2020-08-01, Saturday

         - [ ] Develop photos
         - [x] Pay bills

         ## 2020-07-31, Friday

         - [x] Review open pull requests
         - [x] Fix the flaky test
         ```)))

(run-tests!)
