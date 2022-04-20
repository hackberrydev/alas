(import testament :prefix "" :exit true)

(import ../../src/date :as d)
(import ../../src/contact)
(import ../../src/plan)
(import ../../src/day)
(import ../../src/commands/schedule_contacts :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test schedule-contacts

(deftest schedule-contacts-for-today
  (def contact (contact/build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (is (= {:title "Contact John Doe" :done false}
         ((((plan :days) 0) :tasks) 0))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest build-command-without-matching-argument
  (def arguments {"stats" true})
  (is (empty? (build-command arguments))))

(deftest build-command-with-correct-arguments
  (def arguments {"schedule-contacts" "test/examples/contacts"})
  (def result (build-command arguments))
  (is (tuple? (result :command))))

(deftest build-command-when-contacts-directory-does-not-exist
  (def arguments {"schedule-contacts" "test/examples/people"})
  (def result (build-command arguments))
  (is (nil? (result :command)))
  (is (= "--schedule-contacts directory does not exist." (first (result :errors)))))

(run-tests!)
