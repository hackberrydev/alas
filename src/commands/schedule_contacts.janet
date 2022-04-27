### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../contact)
(import ../task)
(import ../day)
(import ../plan)
(import ../contact/repository :as contacts_repository)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def contacts-to-schedule (filter (fn [c] (contact/contact-on-date? c date)) contacts))
  (def day (plan/day-with-date plan date))
  (loop [contact :in contacts-to-schedule]
    (day/add-task day (task/build-task (string "Contact " (contact :name)) false)))
  plan)

(defn build-command [arguments &]
  (def argument (arguments "schedule-contacts"))
  (if argument
    (let [load-result (contacts_repository/load-contacts argument)
          error (load-result :error)]
      (if error
        {:errors [(string "--schedule-contacts " (string/ascii-lower error))]}
        {}))
    {}))
