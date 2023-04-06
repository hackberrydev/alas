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

(defn- schedule-missed-birthday-tasks [plan contacts today]
  (def day (plan/day-with-date plan today))
  (loop [contact :in contacts]
    (let [birthday (missed-birthday plan contact today)]
      (if birthday
        (day/add-task day
                      (task/mark-as-missed (build-task birthday-prefix contact)
                                           (birthday :date)))))))

(defn- schedule-tasks [plan contacts today prefix predicate]
  (def future-days (reverse (plan/days-on-or-after plan today)))
  (loop [day :in future-days
         contact :in contacts]
    (let [task (build-task prefix contact)]
      (if (and (predicate contact (day :date))
               (not (plan/has-task-on-or-after? plan task today)))
        (day/add-task day task)))))

(defn- schedule-contact-tasks [plan contacts today]
  (schedule-tasks plan contacts today contact-prefix contact/contact-on-date?))

(defn- schedule-birthday-tasks [plan contacts today]
  (schedule-tasks plan contacts today birthday-prefix contact/birthday?))

(defn- format-command-errors [command errors]
  (map (fn [error] (string command " " (string/ascii-lower error) ".")) errors))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-contacts [plan contacts today]
  (schedule-contact-tasks plan contacts today)
  (schedule-birthday-tasks plan contacts today)
  (schedule-missed-birthday-tasks plan contacts today)
  plan)

(defn build-command [arguments &]
  (def argument (arguments "schedule-contacts"))
  (if argument
    (let [load-result (contacts_repository/load-contacts argument)
          errors (load-result :errors)
          contacts (load-result :contacts)]
      (if errors
        {:errors (format-command-errors "--schedule-contacts" errors)}
        {:command [schedule-contacts contacts (date/today)]}))
    {}))
