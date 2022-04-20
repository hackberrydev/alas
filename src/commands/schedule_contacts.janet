### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../contact)
(import ../task)
(import ../day)
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def contacts-to-schedule (filter (fn [c] (contact/contact-on-date? c date)) contacts))
  (def day (plan/day-with-date plan date))
  (loop [contact :in contacts-to-schedule]
    (day/add-task day (task/build-task (string "Contact " (contact :name)) false)))
  plan)

(defn build-command [arguments &]
  {})
