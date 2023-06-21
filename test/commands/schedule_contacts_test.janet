(use judge)

(import ../../src/date :as d)
(import ../../src/contact)
(import ../../src/plan)
(import ../../src/day)
(import ../../src/task)
(import ../../src/commands/schedule_contacts :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test schedule-contacts

(deftest "schedules contacts for today"
  (def contact (contact/build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (test (task :title) "Contact John Doe")
    (test (task :done) false)
    (test (empty? (task :body)) true)))

(deftest "schedules contacts for future"
  (def contact (contact/build-contact "John Doe" :last-contact (d/date 2022 4 1) :category :a))
  (def day-1 (day/build-day (d/date 2022 4 22)))
  (def day-2 (day/build-day (d/date 2022 4 21)))
  (def day-3 (day/build-day (d/date 2022 4 20)))
  (def plan (plan/build-plan :days @[day-1 day-2 day-3]))
  (schedule-contacts plan @[contact] (d/date 2022 4 20))
  (test (empty? (day-1 :tasks)) true)
  (test (not (empty? (day-2 :tasks))) true)
  (test (empty? (day-3 :tasks)) true)
  (if (= 1 (length (day-2 :tasks)))
    (let [task ((day-2 :tasks) 0)]
      (test (task :title) "Contact John Doe")
      (test (task :done) false)
      (test (empty? (task :body)) true))))

(deftest "schedules contacts with birthday"
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (test (task :title) "Congratulate birthday to John Doe")
    (test (task :done) false)
    (test (empty? (task :body)) true)))

(deftest "schedules contacts with missed birthday"
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-25"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def plan (plan/build-plan :days @[(day/build-day (d/date 2022 4 26))
                                     (day/build-day (d/date 2022 4 25))]))
  (schedule-contacts plan @[contact] (d/date 2022 4 26))
  (let [day ((plan :days) 0)
        task ((day :tasks) 0)]
    (test (task :title) "Congratulate birthday to John Doe")
    (test (d/equal? (d/date 2022 4 25) (task :missed-on)) true)))

(deftest "schedules a contact with the birthday on a missed day"
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
  (test (not (empty? (day-1 :tasks))) true)
  (test (length (day-2 :tasks)) 1)
  (if (not (empty? (day-1 :tasks)))
    (let [task ((day-1 :tasks) 0)]
      (test (task :title) "Congratulate birthday to John Doe"))))

(deftest "schedules contact with the birthday on a day in future"
  (def contact (contact/build-contact "John Doe"
                                      :birthday "04-26"
                                      :last-contact (d/date 2022 4 21)
                                      :category :a))
  (def day-1 (day/build-day (d/date 2022 4 26)))
  (def day-2 (day/build-day (d/date 2022 4 25)))
  (def plan (plan/build-plan :days @[day-1 day-2]))
  (schedule-contacts plan @[contact] (d/date 2022 4 25))
  (test (not (empty? (day-1 :tasks))) true)
  (test (empty? (day-2 :tasks)) true)
  (if (not (empty? (day-1 :tasks)))
    (let [task ((day-1 :tasks) 0)]
      (test (task :title) "Congratulate birthday to John Doe")
      (test (not (task :missed-on)) true))))

(deftest "doesn't schedule contact after missed date twice"
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
  (test (empty? (day-1 :tasks)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-command

(deftest "doesn't build the command when arguments are not matching"
  (def arguments {"stats" true})
  (test (empty? (build-command arguments)) true))

(deftest "builds the command when arguments are matching"
  (def arguments {"schedule-contacts" "test/examples/contacts"})
  (def result (build-command arguments))
  (test (tuple? (result :command)) true))

(deftest "returns an error when the contacts directory doesn't exist"
  (def arguments {"schedule-contacts" "test/examples/people"})
  (def result (build-command arguments))
  (test (nil? (result :command)) true)
  (test (first (result :errors)) "--schedule-contacts directory does not exist."))
