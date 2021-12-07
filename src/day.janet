### ————————————————————————————————————————————————————————————————————————————
### This module implements day entity and related functions.

(defn build-day [date &opt events tasks]
  (default events @[])
  (default tasks @[])
  {:date date :events events :tasks tasks})
