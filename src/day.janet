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
    (set date (date/+days date 1)))
  (reverse days))

(defn empty-day? [day]
  (and (empty? (day :events))
       (empty? (day :tasks))))

(defn get-time [day]
  (date/to-time (day :date)))

(defn add-tasks [day tasks]
  (array/concat (day :tasks) tasks))
