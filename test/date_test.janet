(import testament :prefix "" :exit true)
(import ../src/date :as date)

(deftest today-structure
  (let [today (date/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))
    (is (today :week-day))))

(deftest date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Saturday"}
         (date/date 2020 8 31))))

(deftest parse-date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Saturday"}
         (date/parse "2021-08-31"))))

(deftest format-date
  (is (= "2021-08-09" (date/format {:year 2021 :month 8 :day 9}))))

(run-tests!)
