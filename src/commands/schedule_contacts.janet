### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../contact)
(import ../date)
(import ../day)
(import ../plan)
(import ../task)
(import ../contact/repository :as contacts_repository)

(def birthday-title "Congratulate birthday to ")

(defn- build-task-title [title contact]
  (string title (contact :name)))

(defn- build-task [title contact]
  (task/build-task (build-task-title title contact) false))

(defn- scheduled-tasks [contacts day predicate task-title]
  (def date (day :date))
  (map (fn [contact] (build-task task-title contact))
       (filter (fn [c] (predicate c date)) contacts)))


(defn- birthdays [plan contact]
  (filter (fn [day] (contact/birthday? contact (day :date)))
          (reverse (plan :days))))

(defn- missed-birthday? [plan contact date]
  (def task (build-task birthday-title contact))
  (find (fn [day] (and (day/missed-task? day task)
                       (not (plan/has-task-after? plan task (day :date)))))
        (birthdays plan contact)))

(defn- birthday-predicate [plan]
  (fn [contact date]
    (or (contact/birthday? contact date)
        (missed-birthday? plan contact date))))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts date]
  (def day (plan/day-with-date plan date))
  (day/add-tasks day (scheduled-tasks contacts day contact/contact-on-date? "Contact "))
  (day/add-tasks day (scheduled-tasks contacts day contact/birthday? birthday-title))
  (day/add-tasks day (scheduled-tasks contacts
                                      day
                                      (fn [contact date] (missed-birthday? plan contact date))
                                      birthday-title))
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
