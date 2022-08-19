### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../date)
(import ../contact)
(import ../task)
(import ../day)
(import ../plan)
(import ../contact/repository :as contacts_repository)

(def birthday-title "Congratulate birthday to ")

(defn- build-task-title [title contact]
  (string title (contact :name)))

(defn- schedule-tasks [contacts day predicate task-title]
  (def date (day :date))
  (each contact
    (filter (fn [c] (predicate c date)) contacts)
    (day/add-task day (task/build-task (build-task-title task-title contact) false))))

(defn- missed-birthday? [plan contact date]
  (find (fn [day] (and (contact/birthday? contact (day :date))
                       (not (day/has-task? day (build-task-title birthday-title contact)))))
        (reverse (plan :days))))

(defn- birthday-predicate [plan]
  (fn [contact date]
    (or (contact/birthday? contact date)
        (missed-birthday? plan contact date))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def day (plan/day-with-date plan date))
  (schedule-tasks contacts day contact/contact-on-date? "Contact ")
  (schedule-tasks contacts day (birthday-predicate plan) birthday-title)
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
