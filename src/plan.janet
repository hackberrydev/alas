### ————————————————————————————————————————————————————————————————————————————
### This module implements plan entity and related functions.

(import ./date)
(import ./day)

(defn- tasks-from-days [days]
  (array/concat @[] (splice (map (fn [day] (day :tasks)) days))))

(defn- days-between [plan start-date end-date]
  (defn- day-in-period? [day]
    (def date (day :date))
    (and (date/after-or-eq? date start-date)
         (date/before-or-eq? date end-date)))
  (filter day-in-period? (plan :days)))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn build-plan [&keys {:title title :inbox inbox :days days}]
  (default title "Plan")
  (default inbox @[])
  (default days @[])
  {:title title :inbox inbox :days days})

# ————————————————————————————————————————————————————————————————————————————————————————————————-
# Days functions

(defn has-day-with-date? [plan date]
  (find (fn [day] (date/equal? date (day :date)))
        (plan :days)))

(defn empty-days [plan]
  (filter day/empty-day? (plan :days)))

(defn sort-days [plan]
  (build-plan :title (plan :title)
              :inbox (plan :inbox)
              :days (reverse (sort-by day/get-time (plan :days)))))

(defn insert-days [plan days]
  (loop [day :in days
         :when (not (has-day-with-date? plan (day :date)))]
    (array/push (plan :days) day))
  (sort-days plan))

(defn remove-days [plan days]
  (defn- keep-day? [day] (not (index-of day days)))
  (build-plan :title (plan :title)
              :inbox (plan :inbox)
              :days (filter keep-day? (plan :days))))

(defn days-on-or-after
  ```
  Returns days that are on or after the date.
  ```
  [plan date]
  (take-while (fn [day] (date/after-or-eq? (day :date) date))
              (plan :days)))

# ————————————————————————————————————————————————————————————————————————————————————————————————-
# Tasks functions

(defn all-tasks [plan]
  (tasks-from-days (plan :days)))

(defn tasks-between [plan start-date end-date]
  (tasks-from-days (days-between plan start-date end-date)))

(defn completed-tasks [plan]
  (filter (fn [t] (t :done)) (all-tasks plan)))

(defn pending-tasks [plan]
  (filter (fn [t] (not (t :done))) (all-tasks plan)))
