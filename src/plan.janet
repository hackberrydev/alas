### ————————————————————————————————————————————————————————————————————————————
### This module implements plan entity and related functions.

(import ./date)
(import ./day)

## -----------------------------------------------------------------------------
## Public Interface

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

(defn has-day? [plan date]
  (find (fn [day] (= date (day :date)))
        (plan :days)))

(defn sort-days [plan]
  (def new-days (reverse (sort-by day/get-time (plan :days))))
  (build-plan (plan :title) (plan :inbox) new-days))

(defn insert-days [plan days]
  (loop [day :in days
         :when (not (has-day? plan (day :date)))]
    (array/push (plan :days) day))
  (sort-days plan))

(defn all-tasks [plan]
  (array/concat @[] (splice (map (fn [day] (day :tasks)) plan))))

(defn completed-tasks [plan]
  (filter (fn [t] (t :done)) (all-tasks plan)))

(defn pending-tasks [plan]
  (filter (fn [t] (not (t :done))) (all-tasks plan)))