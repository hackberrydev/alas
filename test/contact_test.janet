(use judge)

(import ../src/contact :prefix "")
(import ../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-contact

(deftest "builds contact with a name"
  (def contact (build-contact "John Doe"))
  (test (contact :name) "John Doe")
  (test (nil? (contact :category)) true)
  (test (nil? (contact :birthday)) true)
  (test (nil? (contact :last-contact)) true))

(deftest "builds contact with a category"
  (def contact (build-contact "John Doe" :category :b))
  (test (contact :name) "John Doe")
  (test (contact :category) :b)
  (test (nil? (contact :birthday)) true)
  (test (nil? (contact :last-contact)) true))

(deftest "builds contact with a string as category"
  (def contact (build-contact "John Doe" :category "B"))
  (test (contact :category) :b))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test next-contact-date

(deftest "calculates the next contact date when a category is :a"
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (test (d/equal? (d/date 2022 4 21) (next-contact-date contact)) true))

(deftest "calculates the next contact date when a category is :b"
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :b))
  (test (d/equal? (d/date 2022 5 31) (next-contact-date contact)) true))

(deftest "returns nil when there's no category"
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1)))
  (test (nil? (next-contact-date contact)) true))

(deftest "returns nil when the last contact is blank"
  (def contact (build-contact "John Doe" :category :b))
  (test (nil? (next-contact-date contact)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test contact-on-date?

(deftest "returns boolean that indicates if the contact should be contacted on the date"
  (def contact (build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (test (contact-on-date? contact (d/date 2022 4 21)) true)
  (test (contact-on-date? contact (d/date 2022 5 1)) true)
  (test (not (contact-on-date? contact (d/date 2022 4 20))) true)
  (test (not (contact-on-date? contact (d/date 2022 4 2))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test birthday?

(deftest "returns boolean that indicates if the date is the contacts birthday"
  (def contact (build-contact "John Doe" :birthday "04-01"))
  (test (birthday? contact (d/date 2022 4 1)) true)
  (test (not (birthday? contact (d/date 2022 4 20))) true))
