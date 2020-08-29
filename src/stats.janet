(defn- all-tasks [schedule]
  (array/concat @[] (splice (map (fn [day] (day :tasks)) schedule))))

(defn- completed-task? [task]
  (string/find "[X]" task))

(defn- pending-task? [task]
  (string/find "[ ]" task))

(defn- completed-tasks [schedule]
  (filter completed-task? (all-tasks schedule)))

(defn- pending-tasks [schedule]
  (filter pending-task? (all-tasks schedule)))

(defn schedule-stats
  ```
  Returns stats for the schedule. For example:
  {
    :days 12
    :completed-tasks 44
    :pending-tasks 5
  }
  ```
  [schedule]
  {:days (length schedule)
   :completed-tasks (length (completed-tasks schedule))
   :pending-tasks (length (pending-tasks schedule))})
