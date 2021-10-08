### ————————————————————————————————————————————————————————————————————————————
### This module implements stats command.

(defn- pluralize [n word]
  (if (= n 1)
    (string n " " word)
    (string n " " word "s")))

(defn- format-stats [stats]
  (string/join
    @[(pluralize (stats :days) "day")
      (pluralize (stats :completed-tasks) "completed task")
      (pluralize (stats :pending-tasks) "pending task")]
    "\n"))

(defn- all-tasks [todo]
  (array/concat @[] (splice (map (fn [day] (day :tasks)) todo))))

(defn- completed-task? [task]
  (string/find "[X]" task))

(defn- pending-task? [task]
  (string/find "[ ]" task))

(defn- completed-tasks [todo]
  (filter completed-task? (all-tasks todo)))

(defn- pending-tasks [todo]
  (filter pending-task? (all-tasks todo)))

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
  [todo]
  {:days (length todo)
   :completed-tasks (length (completed-tasks todo))
   :pending-tasks (length (pending-tasks todo))})

(defn formatted-stats
  [todo]
  (format-stats (stats todo)))
