(import testament :prefix "" :exit true)

(import ../../src/commands/list_contacts :prefix "")
(import ../../src/date :as d)
(import ../../src/contact)

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test list-contacts

(deftest list-contacts
  (def contacts @[(contact/build-contact "John Doe")
                  (contact/build-contact "Jane Doe" :birthday "03-21")
                  (contact/build-contact "Marry Doe" :last-contact (d/date 2022 03 15))])
  (def lines (list-contacts contacts))
  (is (= 3 (length lines)))
  (is (= "John Doe,," (lines 0)))
  (is (= "Jane Doe,03-21," (lines 1)))
  (is (= "Marry Doe,,2022-03-15" (lines 2))))

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test build-command

(deftest build-command-without-matching-argument
  (def arguments {"stats" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"list-contacts" "test/examples"})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(deftest build-command-when-directory-does-not-exist
  (def arguments {"list-contacts" "test/examples/contacts"})
  (def result (build-command arguments))
  (is (= "--list-contacts directory does not exist." (first (result :errors)))))


(run-tests!)
