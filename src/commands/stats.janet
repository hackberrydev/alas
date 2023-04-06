### ————————————————————————————————————————————————————————————————————————————
### This module implements stats command.

(import ../utils :prefix "")
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn stats
  ```
  Prints stats for the plan. Returns the plan.
  ```
  [plan]
  (print (pluralize (length (plan :days)) "day"))
  (print (pluralize (length (plan/completed-tasks plan)) "completed task"))
  (print (pluralize (length (plan/pending-tasks plan)) "pending task"))
  plan)

(defn build-command [arguments &]
  (def argument (arguments "stats"))
  (if argument
    {:command [stats]}
    {}))
