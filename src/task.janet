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
  Updates the title to include '(missed on DATE)' label.
  ```
  [task date]
  (def title (string (task :title) " (missed on " (date/format date true) ")"))
  (merge task {:title title}))
