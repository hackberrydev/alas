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

## -----------------------------------------------------------------------------
## Public Interface

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

# ------------------------------------------------------------------------------
# Days functions

(defn has-day-with-date? [plan date]
  (find (fn [day] (date/equal? date (day :date)))
        (plan :days)))

(defn empty-days [plan]
  (filter day/empty-day? (plan :days)))

(defn sort-days [plan]
  (build-plan (plan :title)
              (plan :inbox)
              (reverse (sort-by day/get-time (plan :days)))))

(defn insert-days [plan days]
  (loop [day :in days
         :when (not (has-day-with-date? plan (day :date)))]
    (array/push (plan :days) day))
  (sort-days plan))

(defn remove-days [plan days]
  (defn- keep-day? [day] (not (index-of day days)))
  (build-plan (plan :title)
              (plan :inbox)
              (filter keep-day? (plan :days))))

# ------------------------------------------------------------------------------
# Tasks functions

(defn all-tasks [plan]
  (tasks-from-days (plan :days)))

(defn tasks-between [plan start-date end-date]
  (tasks-from-days (days-between plan start-date end-date)))

(defn completed-tasks [plan]
  (filter (fn [t] (t :done)) (all-tasks plan)))

(defn pending-tasks [plan]
  (filter (fn [t] (not (t :done))) (all-tasks plan)))
