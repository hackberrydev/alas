(import testament :prefix "" :exit true)
(import ../src/date :as date)

(deftest today-structure
  (let [today (date/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))))

(deftest date
  (is (= {:year 2020 :month 8 :day 31} (date/date 2020 8 31))))

(deftest parse-date
  (is (= {:year 2021 :month 8 :day 31} (date/parse "2021-08-31"))))

(run-tests!)
