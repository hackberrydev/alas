### ————————————————————————————————————————————————————————————————————————————————————————————————
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

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn build-plan [&keys {:title title :inbox inbox :days days}]
  (default title "Plan")
  (default inbox @[])
  (default days @[])
  {:title title :inbox inbox :days days})

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Days functions

(defn day-with-date [plan date]
  (find (fn [day] (date/equal? date (day :date)))
        (plan :days)))

(defn has-day-with-date? [plan date]
  (day-with-date plan date))

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

(defn days-before
  ```
  Returns days that are before the date.
  ```
  [plan date]
  (drop-while (fn [day] (date/after-or-eq? (day :date) date))
              (plan :days)))

(defn days-after
  ```
  Returns days that are after the date.
  ```
  [plan date]
  (take-while (fn [day] (date/after? (day :date) date))
              (plan :days)))


(defn days-on-or-after
  ```
  Returns days that are on or after the date.
  ```
  [plan date]
  (take-while (fn [day] (date/after-or-eq? (day :date) date))
              (plan :days)))

(defn all-days
  ```
  Return days from the plan without any 'holes'. For days that are missing, a new day will be
  generated, without any tasks.
  ```
  [plan]
  (var date ((last (plan :days)) :date))
  (reverse
    (flatten
     (map (fn [day]
            (def days (reverse (day/generate-days (date/+days date 1) (date/-days (day :date) 1))))
            (array/push days day)
            (set date (day :date))
            days)
          (reverse (plan :days))))))

(defn all-days-before
  ```
  Return days from the plan without any 'holes' up to the date. For days that are missing, a new day
  will be generated, without any tasks.
  ```
  [plan date]
  (drop-while (fn [day] (date/after-or-eq? (day :date) date))
              (all-days plan)))


## —————————————————————————————————————————————————————————————————————————————————————————————————
## Tasks functions

(defn all-tasks [plan]
  (tasks-from-days (plan :days)))

(defn tasks-between [plan start-date end-date]
  (tasks-from-days (days-between plan start-date end-date)))

(defn completed-tasks [plan]
  (filter (fn [t] (= (t :state) :checked)) (all-tasks plan)))

(defn pending-tasks [plan]
  (filter (fn [t] (= (t :state) :open)) (all-tasks plan)))

(defn has-task-after?
  ```
  Returns true if the plan has the task scheduled on a day after the date.
  ```
  [plan task date]
  (find (fn [day] (day/has-task? day task))
        (days-after plan date)))

(defn has-task-on-or-after?
  ```
  Returns true if the plan has the task scheduled on the day with the date or after.
  ```
  [plan task date]
  (find (fn [day] (day/has-task? day task))
        (days-on-or-after plan date)))
