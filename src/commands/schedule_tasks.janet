### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

(import ../date)
(import ../day)
(import ../plan)
(import ../task)

(import ../file_repository)
(import ../schedule_parser)

(def weekdays ["Monday" "Tuesday" "Wednesday" "Thursday" "Friday"])

(defn- remove-year [formatted-date]
  (string/join (drop 1 (string/split "-" formatted-date)) "-"))

# Public
(defn scheduled-for? [task date]
  (def formatted-date (date/format date true))
  (case (task :schedule)
        (string "every " (date :week-day)) true
        "every weekday" (index-of (date :week-day) weekdays)
        "every month" (= (date :day) 1)
        "every 3 months" (and (= (date :day) 1)
                              (index-of (date :month) [1 4 7 10]))
        (string "every year on " (remove-year formatted-date)) true
        (string "on " formatted-date) true))

(defn- missed-on-day [plan task date]
  (find (fn [day] (and (scheduled-for? task (day :date))
                       (not (day/has-task? day task))))
        (plan/all-days-before plan date)))

# Public
(defn missed?
  ```
  Checks if the task was missed in the plan up to the passed date.

  Returns true or false.
  ```
  [plan task date]
  (def day (missed-on-day plan task date))
  (and day (not (plan/has-task-after? plan task (day :date)))))

(defn- mark-tasks-as-missed [plan tasks date]
  (map (fn [task]
        (let [day (missed-on-day plan task date)]
          (task/mark-as-missed task (day :date))))
       tasks))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-tasks
  [plan scheduled-tasks date]
  (def future-days (reverse (plan/days-on-or-after plan date)))
  (loop [day :in future-days]
    (let [tasks (filter (fn [task] (scheduled-for? task (day :date))) scheduled-tasks)]
      (day/add-tasks day tasks)))
  (loop [day :in future-days]
    (let [tasks (filter (fn [task] (missed? plan task date)) scheduled-tasks)
          missed-tasks (mark-tasks-as-missed plan tasks date)]
      (day/add-tasks day missed-tasks)))

  plan)

(defn build-command [arguments &]
  (def argument (arguments "schedule-tasks"))
  (if argument
    (let [load-file-result (file_repository/load argument)
          error (load-file-result :error)]
      (if error
        {:errors [(string "--schedule-tasks " (string/ascii-lower error))]}
        (let [parse-result (schedule_parser/parse (load-file-result :text))]
          (if parse-result
            (let [schedule (first parse-result)]
              (if (empty? schedule)
                {:errors ["--schedule-tasks schedule is empty."]}
                {:command [schedule-tasks (first parse-result) (date/today)]}))
            {:errors ["--schedule-tasks schedule could not be parsed."]}))))
    {}))
