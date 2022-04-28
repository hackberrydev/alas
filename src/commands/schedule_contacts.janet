### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../date)
(import ../contact)
(import ../task)
(import ../day)
(import ../plan)
(import ../contact/repository :as contacts_repository)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def day (plan/day-with-date plan date))
  (each contact
    (filter (fn [c] (contact/contact-on-date? c date)) contacts)
    (day/add-task day (task/build-task (string "Contact " (contact :name)) false)))
  (each contact
    (filter (fn [c] (contact/birthday? c date)) contacts)
    (day/add-task day (task/build-task (string "Congratulate birthday to " (contact :name)) false)))
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
