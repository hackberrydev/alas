### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements task entity and related functions.

(import ./date)

(def states [:open :checked])

(defn build-task [title state &opt body]
  (default body @[])
  (if (index-of state states)
    {:title title :body body :state state}
    (error (string "task doesn't support the state '" state "'"))))

(defn build-scheduled-task [line title schedule]
  (def task (build-task title :open))
  (merge task {:line line :schedule schedule}))

(defn build-missed-task [title date &opt body]
  (def task (build-task title :open body))
  (merge task {:missed-on date}))

(defn build-contact-task [title contact &opt body]
  (def task (build-task title :open body))
  (merge task {:contact contact}))

(defn mark-as-missed
  ```
  Adds :missed-on key to the task.
  ```
  [task date]
  (merge task {:missed-on date}))
