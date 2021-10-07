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

(deftest parse
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (date/parse "2020-08-31"))))

(deftest format
  (is (= "2021-08-09, Monday")
      (date/format {:year 2021 :month 8 :day 9 :week-day "Monday"})))

(deftest before?
  (is (date/before? (date/date 2021 7 1) (date/date 2021 7 2)))
  (is (date/before? (date/date 2021 7 1) (date/date 2021 7 10)))
  (is (not (date/before? (date/date 2021 7 1) (date/date 2021 6 15))))
  (is (not (date/before? (date/date 2021 7 1) (date/date 2021 7 1)))))

(run-tests!)
