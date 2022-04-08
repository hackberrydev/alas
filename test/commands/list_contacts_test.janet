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

(run-tests!)
