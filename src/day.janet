### ————————————————————————————————————————————————————————————————————————————
### This module implements day entity and related functions.

(import ./date)

(defn build-day [date &opt events tasks]
  (default events @[])
  (default tasks @[])
  {:date date :events events :tasks tasks})

(defn generate-days [from-date to-date]
  (def days @[])
  (var date from-date)
  (while (date/before-or-eq? date to-date)
    (array/push days (build-day date))
    (set date (date/next-day date)))
  (reverse days))

(defn get-time [day]
  (date/to-time (day :date)))
