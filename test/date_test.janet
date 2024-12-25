(use judge)

(import ../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test today

(deftest "returns the correct struct"
  (let [today (d/today)]
    (test (not (nil? (today :year))) true)
    (test (not (nil? (today :month))) true)
    (test (not (nil? (today :day))) true)
    (test (not (nil? (today :week-day))) true)))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test date

(deftest "returns the correct struct"
  (test (d/date 2020 8 31)
        {:year 2020 :month 8 :day 31 :week-day "Monday"}))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse

(deftest "parses a string to a date"
  (test (d/parse "2020-08-31")
        {:year 2020 :month 8 :day 31 :week-day "Monday"}))
## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test format

(deftest "returns a correctly formatted string for the date"
  (test (d/format {:year 2021 :month 8 :day 9 :week-day "Monday"})
        "2021-08-09, Monday"))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test before?

(deftest "returns true when the first date is before the second date"
  (test (d/before? (d/date 2021 7 1) (d/date 2021 7 2)) true)
  (test (d/before? (d/date 2021 7 1) (d/date 2021 7 10)) true)
  (test (not (d/before? (d/date 2021 7 1) (d/date 2021 6 15))) true)
  (test (not (d/before? (d/date 2021 7 1) (d/date 2021 7 1))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test before-or-eq?

(deftest "returns true when the first date is before or equal to the second date"
  (test (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 2)) true)
  (test (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 10)) true)
  (test (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 7 1)) true)
  (test (not (d/before-or-eq? (d/date 2021 7 1) (d/date 2021 6 15))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test after?

(deftest "returns true when the first date is after the second date"
  (test (d/after? (d/date 2021 7 3) (d/date 2021 7 2)) true)
  (test (d/after? (d/date 2021 7 3) (d/date 2021 6 10)) true)
  (test (not (d/after? (d/date 2021 7 1) (d/date 2021 7 15))) true)
  (test (not (d/after? (d/date 2021 7 1) (d/date 2021 7 1))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test after-or-eq?

(deftest "returns true when the first date is after or equal to the second date"
  (test (d/after-or-eq? (d/date 2021 7 3) (d/date 2021 7 2)) true)
  (test (d/after-or-eq? (d/date 2021 7 3) (d/date 2021 6 10)) true)
  (test (d/after-or-eq? (d/date 2021 7 1) (d/date 2021 7 1)) true)
  (test (not (d/after-or-eq? (d/date 2021 7 1) (d/date 2021 7 15))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test weekday?

(deftest "returns true if the date is a weekday"
  (test (d/weekday? (d/date 2022 1 3)) true)
  (test (d/weekday? (d/date 2022 1 4)) true)
  (test (d/weekday? (d/date 2022 1 5)) true)
  (test (d/weekday? (d/date 2022 1 6)) true)
  (test (d/weekday? (d/date 2022 1 7)) true)
  (test (d/weekday? (d/date 2022 1 8)) false)
  (test (d/weekday? (d/date 2022 1 9)) false))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test last-day-of-month?

(deftest "returns true when the date is the last date of the month"
  (test (d/last-day-of-month? (d/date 2022 1 31)) true)
  (test (d/last-day-of-month? (d/date 2022 2 28)) true)
  (test (d/last-day-of-month? (d/date 2022 3 31)) true)
  (test (d/last-day-of-month? (d/date 2022 4 30)) true)
  (test (d/last-day-of-month? (d/date 2022 5 31)) true)
  (test (d/last-day-of-month? (d/date 2022 6 30)) true)
  (test (d/last-day-of-month? (d/date 2022 7 31)) true)
  (test (d/last-day-of-month? (d/date 2022 8 31)) true)
  (test (d/last-day-of-month? (d/date 2022 9 30)) true)
  (test (d/last-day-of-month? (d/date 2022 10 31)) true)
  (test (d/last-day-of-month? (d/date 2022 11 30)) true)
  (test (d/last-day-of-month? (d/date 2022 12 31)) true)
  (test (d/last-day-of-month? (d/date 2023 1 31)) true)
  (test (not (d/last-day-of-month? (d/date 2022 1 30))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test last-weekday-of-month?

(deftest "returns true when the date is the last week day of the month"
  (test (d/last-weekday-of-month? (d/date 2022 1 31)) true)
  (test (d/last-weekday-of-month? (d/date 2022 2 28)) true)
  (test (d/last-weekday-of-month? (d/date 2022 3 31)) true)
  (test (d/last-weekday-of-month? (d/date 2022 4 29)) true)
  (test (d/last-weekday-of-month? (d/date 2022 5 31)) true)
  (test (d/last-weekday-of-month? (d/date 2022 6 30)) true)
  (test (d/last-weekday-of-month? (d/date 2022 7 29)) true)
  (test (d/last-weekday-of-month? (d/date 2022 8 31)) true)
  (test (d/last-weekday-of-month? (d/date 2022 9 30)) true)
  (test (d/last-weekday-of-month? (d/date 2022 10 31)) true)
  (test (d/last-weekday-of-month? (d/date 2022 11 30)) true)
  (test (d/last-weekday-of-month? (d/date 2022 12 30)) true)
  (test (not (d/last-weekday-of-month? (d/date 2022 1 30))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test last-friday-of-month?

(deftest "returns true when the date is the last friday of the month"
  (test (d/last-friday-of-month? (d/date 2022 1 28)) true)
  (test (d/last-friday-of-month? (d/date 2022 2 25)) true)
  (test (d/last-friday-of-month? (d/date 2022 3 25)) true)
  (test (d/last-friday-of-month? (d/date 2022 4 29)) true)
  (test (d/last-friday-of-month? (d/date 2022 5 27)) true)
  (test (not (d/last-friday-of-month? (d/date 2022 1 31))) true)
  (test (not (d/last-friday-of-month? (d/date 2022 1 21))) true)
  (test (not (d/last-friday-of-month? (d/date 2022 2 11))) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test +days

(deftest "adds the number of days to the date"
  (test (= (d/date 2020 8 6) (d/+days (d/date 2020 8 5) 1)) true)
  (test (= (d/date 2020 8 7) (d/+days (d/date 2020 8 5) 2)) true)
  (test (= (d/date 2020 8 8) (d/+days (d/date 2020 8 5) 3)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test -days

(deftest "substract the number of days from the date"
  (test (= (d/date 2020 8 4) (d/-days (d/date 2020 8 5) 1)) true)
  (test (= (d/date 2020 8 3) (d/-days (d/date 2020 8 5) 2)) true)
  (test (= (d/date 2020 8 2) (d/-days (d/date 2020 8 5) 3)) true))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test days-from-now

(deftest "adds the number of days to today"
  (test (= (d/days-from-now 1) (d/+days (d/today) 1)) true)
  (test (= (d/days-from-now 2) (d/+days (d/today) 2)) true))
