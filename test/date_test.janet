(import testament :prefix "" :exit true)
(import ../src/date :as d)

(deftest today-structure
  (let [today (d/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))
    (is (today :week-day))))

(deftest date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (d/date 2020 8 31))))

(deftest parse
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (d/parse "2020-08-31"))))

(deftest format
  (is (= "2021-08-09, Monday")
      (d/format {:year 2021 :month 8 :day 9 :week-day "Monday"})))

(deftest before?
  (is (d/before? (d/date 2021 7 1) (d/date 2021 7 2)))
  (is (d/before? (d/date 2021 7 1) (d/date 2021 7 10)))
  (is (not (d/before? (d/date 2021 7 1) (d/date 2021 6 15))))
  (is (not (d/before? (d/date 2021 7 1) (d/date 2021 7 1)))))

(deftest next-day
  (is (= (d/next-day (d/date 2021 7 1)) (d/date 2021 7 2)))
  (is (= (d/next-day (d/date 2021 7 31)) (d/date 2021 8 1))))

(run-tests!)
