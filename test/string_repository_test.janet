(import testament :prefix "" :exit true)
(import ../src/date :prefix "")
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
- [x] Fix the flaki test
```)

(deftest load-string-into-entities
  (let [days (repo/load todo)]
    (is (= 2 (length days)))
    (is (= (date 2020 8 1) ((days 0) :date)))
    (is (= 5 ((days 0) :line-number)))
    (is (= false ((days 0) :changed)))
    (is (= (date 2020 7 31) ((days 1) :date)))
    (is (= 10 ((days 1) :line-number)))
    (is (= false ((days 1) :changed)))))

(run-tests!)
