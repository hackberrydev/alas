### ————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-tasks
  [plan scheduled-tasks date]
  (each day
        (plan/days-on-or-after plan date)
        (fn [day] (schedule-tasks day scheduled-tasks)))
  plan)
