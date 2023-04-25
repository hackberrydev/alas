(import testament :prefix "" :exit true)
(import ../src/date :as d)

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test today

(deftest today-structure
  (let [today (d/today)]
    (is (today :year))
    (is (today :month))
    (is (today :day))
    (is (today :week-day))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test date

(deftest date
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (d/date 2020 8 31))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse

(deftest parse
  (is (= {:year 2020 :month 8 :day 31 :week-day "Monday"}
         (d/parse "2020-08-31"))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test format

(deftest format
  (is (= "2021-08-09, Monday")
      (d/format {:year 2021 :month 8 :day 9 :week-day "Monday"})))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test before?

(deftest before?
  (is (d/before? (d/date 2021 7 1) (d/date 2021 7 2)))
  (is (d/before? (d/date 2021 7 1) (d/date 2021 7 10)))
  (is (not (d/before? (d/date 2021 7 1) (d/date 2021 6 15))))
  (is (not (d/before? (d/date 2021 7 1) (d/date 2021 7 1)))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test before-or-eq?

(deftest before-or-eq?
  (is (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 2)))
  (is (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 10)))
  (is (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 1)))
  (is (not (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 6 15)))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test after?

(deftest after?
  (is (d/after? (d/date 2021 7 3) (d/date 2021 7 2)))
  (is (d/after? (d/date 2021 7 3) (d/date 2021 6 10)))
  (is (not (d/after? (d/date 2021 7 1) (d/date 2021 7 15))))
  (is (not (d/after? (d/date 2021 7 1) (d/date 2021 7 1)))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test after-or-eq?

(deftest after-or-eq?
  (is (d/after-or-eq? (d/date 2021 7 3) (d/date 2021 7 2)))
  (is (d/after-or-eq? (d/date 2021 7 3) (d/date 2021 6 10)))
  (is (d/after-or-eq? (d/date 2021 7 1) (d/date 2021 7 1)))
  (is (not (d/after-or-eq? (d/date 2021 7 1) (d/date 2021 7 15)))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test last-day-of-month?

(deftest last-day-of-month?
  (is (d/last-day-of-month? (d/date 2022 1 31)))
  (is (d/last-day-of-month? (d/date 2022 2 28)))
  (is (d/last-day-of-month? (d/date 2022 3 31)))
  (is (d/last-day-of-month? (d/date 2022 4 30)))
  (is (d/last-day-of-month? (d/date 2022 5 31)))
  (is (d/last-day-of-month? (d/date 2022 6 30)))
  (is (d/last-day-of-month? (d/date 2022 7 31)))
  (is (d/last-day-of-month? (d/date 2022 8 31)))
  (is (d/last-day-of-month? (d/date 2022 9 30)))
  (is (d/last-day-of-month? (d/date 2022 10 31)))
  (is (d/last-day-of-month? (d/date 2022 11 30)))
  (is (d/last-day-of-month? (d/date 2022 12 31)))
  (is (d/last-day-of-month? (d/date 2023 1 31)))
  (is (not (d/last-day-of-month? (d/date 2022 1 30)))))


## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test +days

(deftest +days
  (is (= (d/date 2020 8 6) (d/+days (d/date 2020 8 5) 1)))
  (is (= (d/date 2020 8 7) (d/+days (d/date 2020 8 5) 2)))
  (is (= (d/date 2020 8 8) (d/+days (d/date 2020 8 5) 3))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test -days

(deftest -days
  (is (= (d/date 2020 8 4) (d/-days (d/date 2020 8 5) 1)))
  (is (= (d/date 2020 8 3) (d/-days (d/date 2020 8 5) 2)))
  (is (= (d/date 2020 8 2) (d/-days (d/date 2020 8 5) 3))))

## ————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-from-now

(deftest days-from-now
  (is (= (d/days-from-now 1) (d/+days (d/today) 1)))
  (is (= (d/days-from-now 2) (d/+days (d/today) 2))))

(run-tests!)
