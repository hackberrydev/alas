### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements task entity and related functions.

(import ./date)

(defn build-task [title done &opt body]
  (default body @[])
  {:title title :body body :done done})

(defn build-scheduled-task [title schedule &opt body]
  (default body @[])
  {:title title :body body :done false :schedule schedule})

(defn mark-as-missed
  ```
  Adds :missed-on key to the task.
  ```
  [task date]
  (merge task {:missed-on date}))
