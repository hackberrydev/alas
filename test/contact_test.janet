(import testament :prefix "" :exit true)

(import ../src/contact :prefix "")
(import ../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-contact

(deftest build-contact-with-name
  (def contact (build-contact "John Doe"))
  (is (= (contact :name) "John Doe"))
  (is (nil? (contact :category)))
  (is (nil? (contact :birthday)))
  (is (nil? (contact :last-contact))))

(deftest build-contact-with-category
  (def contact (build-contact "John Doe" :category :b))
  (is (= (contact :name) "John Doe"))
  (is (= :b (contact :category)))
  (is (nil? (contact :birthday)))
  (is (nil? (contact :last-contact))))

(deftest build-contact-with-string-category
  (def contact (build-contact "John Doe" :category "B"))
  (is (= :b (contact :category))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test next-contact-date

(deftest next-contact-date-with-category-a
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (is (d/equal? (d/date 2022 4 21) (next-contact-date contact))))

(deftest next-contact-date-with-category-b
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :b))
  (is (d/equal? (d/date 2022 5 31) (next-contact-date contact))))

(deftest next-contact-date-without-category
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1)))
  (is (nil? (next-contact-date contact))))

(deftest next-contact-date-without-last-contact
  (def contact (build-contact "John Doe" :category :b))
  (is (nil? (next-contact-date contact))))

(run-tests!)
