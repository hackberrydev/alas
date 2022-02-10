### ————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

(import ../day)
(import ../date)
(import ../plan)
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

(defn- schedule-tasks-for-day [day scheduled-tasks]
  (def tasks (filter (fn [task] (scheduled-for? task (day :date)))
                     scheduled-tasks))
  (day/add-tasks day tasks))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-tasks
  [plan scheduled-tasks date]
  (loop [day :in (plan/days-on-or-after plan date)]
    (schedule-tasks-for-day day scheduled-tasks))
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
            {:command [schedule-tasks (first parse-result) (date/today)]}
            {:errors ["--schedule-tasks schedule could not be parsed."]}))))
    {}))
