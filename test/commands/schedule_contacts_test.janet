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

(run-tests!)
