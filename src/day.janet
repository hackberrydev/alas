### ————————————————————————————————————————————————————————————————————————————
### This module implements day entity and related functions.

(import ./date :as d)

(defn build-day [date &opt events tasks]
  (default events @[])
  (default tasks @[])
  {:date date :events events :tasks tasks})

(defn generate-days [from-date to-date]
  (def days @[])
  (var date from-date)
  (while (d/before-or-eq? date to-date)
    (array/push days (build-day date))
    (set date (d/next-day date)))
  (reverse days))
