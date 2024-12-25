### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

(import ../utils :prefix "")

(import ../date)
(import ../day)
(import ../plan)
(import ../task)

(import ../errors)
(import ../file_repository)
(import ../schedule_parser)

(def command "--schedule-tasks")
(def weekdays ["Monday" "Tuesday" "Wednesday" "Thursday" "Friday"])

(defn- remove-year [formatted-date]
  (string/join (drop 1 (string/split "-" formatted-date)) "-"))

# Public
(defn scheduled-for? [task date]
  (def formatted-date (date/format date true))
  (case (task :schedule)
        (string "every " (date :week-day)) true
        "every weekday" (number? (index-of (date :week-day) weekdays))
        "every month" (= (date :day) 1)
        "every 3 months" (and (= (date :day) 1)
                              (number? (index-of (date :month) [1 4 7 10])))
        (string "every month on " (date :day)) true
        (string "every year on " (remove-year formatted-date)) true
        (string "on " formatted-date) true
        "every last day" (date/last-day-of-month? date)
        "every last weekday" (date/last-weekday-of-month? date)
        "every last Friday" (date/last-friday-of-month? date)
        false))

(defn- missed-on-day [plan task date]
  (find (fn [day] (and (scheduled-for? task (day :date))
                       (not (day/has-task? day task))))
        (plan/all-days-before plan date)))

(defn- older-than-30-days? [date today]
  (date/before? date (date/-days today 30)))

# Public
(defn missed?
  ```
  Checks if the task was missed in the plan up to the passed date.

  Returns true or false.

  plan - The plan.
  task - The scheduled task.
  date - A date. Typically today.
  ```
  [plan task date]
  (def day (missed-on-day plan task date))
  (and day
       (not (older-than-30-days? (day :date) date))
       (not (plan/has-task-after? plan task (day :date)))))

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
          file-errors (load-file-result :errors)]
      (if (any? file-errors)
        {:errors (errors/format-command-errors command file-errors)}
        (let [parse-result (schedule_parser/parse (load-file-result :text))
              parse-errors (parse-result :errors)]
          (if (any? parse-errors)
            {:errors (errors/format-command-errors command parse-errors)}
            {:command [schedule-tasks (parse-result :tasks) (date/today)]
             :errors []}))))
    {}))
