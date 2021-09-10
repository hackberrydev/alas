(import testament :prefix "" :exit true)
(import ../src/date :as date)

(deftest today-structure
  (let [today (date/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))))
