### ————————————————————————————————————————————————————————————————————————————
### This module implements stats command.

(import ../utils :as "u")
(import ../plan)

(defn- format-stats [stats]
  (string/join
    @[(u/pluralize (stats :days) "day")
      (u/pluralize (stats :completed-tasks) "completed task")
      (u/pluralize (stats :pending-tasks) "pending task")]
    "\n"))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn stats
  ```
  Returns stats for the todo. For example:
  {
    :days 12
    :completed-tasks 44
    :pending-tasks 5
  }
  ```
  [plan]
  {:days (length plan)
   :completed-tasks (length (plan/completed-tasks plan))
   :pending-tasks (length (plan/pending-tasks plan))})

(defn formatted-stats
  [plan]
  (format-stats (stats plan)))
