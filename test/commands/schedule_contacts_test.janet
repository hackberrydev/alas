(import testament :prefix "" :exit true)

(import ../../src/date :as d)
(import ../../src/contact)
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_contacts :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test schedule-contacts

(deftest schedule-contacts-for-today
  (def contact (contact/build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (is (= "Contact John Doe" (task :title)))
    (is (= false (task :done)))
    (is (empty? (task :body)))))

(deftest schedule-contact-with-birthday
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (is (= "Congratulate birthday to John Doe" (task :title)))
    (is (= false (task :done)))
    (is (empty? (task :body)))))

(deftest schedule-contact-with-missed-birthday
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 26))
                                     (day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 26))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (is (= "Congratulate birthday to John Doe (missed on 2022-04-25)" (task :title)))))

(deftest schedule-contact-with-birthday-on-a-missed-day
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def day-1 (day/build-day (d/date 2022 4 26)))
  (def day-2 (day/build-day (d/date 2022 4 25)
                            @[]
                            @[(task/build-task "Weekly meeting" false)]))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (schedule-contacts plan @[contact] (d/date 2022 4 26))
  (is (not (empty? (day-1 :tasks))))
  (is (= 1 (length (day-2 :tasks))))
  (if (not (empty? (day-1 :tasks)))
    (let [task ((day-1 :tasks) 0)]
      (is (= "Congratulate birthday to John Doe" (task :title)))
      (is (= false (task :done)))
      (is (empty? (task :body))))))

(deftest schedule-contact-does-not-schedule-after-missed-date-twice
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def day-1 (day/build-day (d/date 2022 4 27)))
  (def day-2 (day/build-day (d/date 2022 4 26)
                            @[]
                            @[(task/build-task "Congratulate birthday to John Doe" true)]))
  (def day-3 (day/build-day (d/date 2022 4 25)
                            @[]
                            @[(task/build-task "Weekly meeting" false)]))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3]))
  (schedule-contacts plan @[contact] (d/date 2022 4 27))
  (is (empty? (day-1 :tasks))))

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
