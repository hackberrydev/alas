(import testament :prefix "" :exit true)
(import ../src/contact)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-contact

(deftest build-contact-with-name
  (def contact (contact/build-contact "John Doe"))
  (is (= (contact :name) "John Doe"))
  (is (nil? (contact :category)))
  (is (nil? (contact :birthday)))
  (is (nil? (contact :last-contact))))

(deftest build-contact-with-category
  (def contact (contact/build-contact "John Doe" :category :b))
  (is (= (contact :name) "John Doe"))
  (is (= :b (contact :category)))
  (is (nil? (contact :birthday)))
  (is (nil? (contact :last-contact))))

(deftest build-contact-with-string-category
  (def contact (contact/build-contact "John Doe" :category "B"))
  (is (= :b (contact :category))))

(run-tests!)
