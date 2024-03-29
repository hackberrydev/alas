### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements task entity and related functions.

(import ./date)

(defn build-task [title done &opt body]
  (default body @[])
  {:title title :body body :done done})

(defn build-scheduled-task [line title schedule]
  {:line line :title title :done false :schedule schedule})

(defn build-missed-task [title date &opt body]
  (default body @[])
  {:title title :body body :done false :missed-on date})

(defn build-contact-task [title contact &opt body]
  (default body @[])
  {:title title :body body :done false :contact contact})

(defn mark-as-missed
  ```
  Adds :missed-on key to the task.
  ```
  [task date]
  (merge task {:missed-on date}))
