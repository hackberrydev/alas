(use judge)

(import ../../src/commands/list_contacts :prefix "")
(import ../../src/date :as d)
(import ../../src/contact)

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test list-contacts

(deftest "#list-contacts"
  (def contacts @[(contact/build-contact "John Doe" :category :a)
                  (contact/build-contact "Jane Doe" :birthday "03-21")
                  (contact/build-contact "Marry Doe" :last-contact (d/date 2022 03 15))])
  (def lines (list-contacts contacts))
  (test (length lines) 3)
  (test (lines 0) "John Doe,a,,")
  (test (lines 1) "Jane Doe,,03-21,")
  (test (lines 2) "Marry Doe,,,2022-03-15"))

## ————————————————————————————————————————————————————————————————————————————————————————————————–
## Test build-command

(deftest "without matching arguments"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "with correct arguments"
  (def arguments {"list-contacts" "test/examples/contacts"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))

(deftest "when the directory doesn't exist"
  (def arguments {"list-contacts" "test/missing-directory"})
  (def result (build-command arguments))
  (test (first (result :errors)) "--list-contacts directory does not exist."))
