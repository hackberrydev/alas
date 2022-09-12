### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling contacts for today in a plan.

(import ../contact)
(import ../date)
(import ../day)
(import ../plan)
(import ../task)
(import ../contact/repository :as contacts_repository)

(def contact-prefix "Contact ")
(def birthday-prefix "Congratulate birthday to ")

(defn- build-task-title [prefix contact]
  (string prefix (contact :name)))

(defn- build-task [prefix contact]
  (task/build-contact-task (build-task-title prefix contact) contact))

(defn- birthdays [plan contact]
  (filter (fn [day] (contact/birthday? contact (day :date)))
          (reverse (plan :days))))

(defn- missed-birthday [plan contact date]
  (def task (build-task birthday-prefix contact))
  (find (fn [day] (and (day/missed-task? day task)
                       (not (plan/has-task-after? plan task (day :date)))))
        (birthdays plan contact)))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts today]
  (def day (plan/day-with-date plan today))
  (def future-days (reverse (plan/days-on-or-after plan today)))
  (loop [day :in future-days
         contact :in contacts]
    (let [task (build-task contact-prefix contact)]
      (if (and (contact/contact-on-date? contact (day :date))
               (not (plan/has-task-on-or-after? plan task today)))
        (day/add-task day task))))
  (loop [day :in future-days
         contact :in contacts]
    (let [task (build-task birthday-prefix contact)]
      (if (and (contact/birthday? contact (day :date))
               (not (plan/has-task-on-or-after? plan task today)))
        (day/add-task day task))))
  (loop [contact :in contacts]
    (let [birthday (missed-birthday plan contact today)]
      (if birthday
        (let [task (task/mark-as-missed (build-task birthday-prefix contact) (birthday :date))]
          (day/add-task day task)))))
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
