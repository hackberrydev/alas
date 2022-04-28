### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../date)
(import ../contact)
(import ../task)
(import ../day)
(import ../plan)
(import ../contact/repository :as contacts_repository)

(defn- schedule-tasks [contacts day predicate task-title]
  (def date (day :date))
  (each contact
    (filter (fn [c] (predicate c date)) contacts)
    (day/add-task day (task/build-task (string task-title (contact :name)) false))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def day (plan/day-with-date plan date))
  (schedule-tasks contacts day contact/contact-on-date? "Contact ")
  (schedule-tasks contacts day contact/birthday? "Congratulate birthday to ")
  plan)

(defn build-command [arguments &]
  (def argument (arguments "schedule-contacts"))
  (if argument
    (let [load-result (contacts_repository/load-contacts argument)
          error (load-result :error)
          contacts (load-result :contacts)]
      (if error
        {:errors [(string "--schedule-contacts " (string/ascii-lower error))]}
        {:command [schedule-contacts contacts (date/today)]}))
    {}))
