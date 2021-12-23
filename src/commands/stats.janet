### ————————————————————————————————————————————————————————————————————————————
### This module implements stats command.

(import ../utils :as "u")
(import ../plan)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn stats
  ```
  Prints stats for the plan. Returns the plan.
  ```
  [plan]
  (print (u/pluralize (length (plan :days)) "day"))
  (print (u/pluralize (length (plan/completed-tasks plan)) "completed tasks"))
  (print (u/pluralize (length (plan/pending-tasks plan)) "pending task"))
  plan)
