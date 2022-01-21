### ————————————————————————————————————————————————————————————————————————————
### This module implements a command for scheduling days for today in a plan.

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn schedule-tasks
  [plan scheduled-tasks date]
  (loop [task :in scheduled-tasks]
    (print "- " (task :title)))
  plan)
