### ————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

(import ../day)
(import ../date)
(import ../plan)

(def weekdays ["Monday" "Tuesday" "Wednesday" "Thursday" "Friday"])

# Public
(defn scheduled-for? [task date]
  (case (task :schedule)
        (string "every " (date :week-day)) true
        "every month" (= (date :day) 1)
        "every weekday" (index-of (date :week-day) weekdays)))

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
