(import testament :prefix "" :exit true)
(import ../src/date :as date)

(deftest today-structure
  (let [today (date/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))
    (is (today :week-day))))

(deftest date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (date/date 2020 8 31))))

(deftest parse-date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (date/parse "2020-08-31"))))

(deftest format-date
  (is (= "2021-08-09, Monday")
      (date/format {:year 2021 :month 8 :day 9 :week-day "Monday"})))

(run-tests!)
