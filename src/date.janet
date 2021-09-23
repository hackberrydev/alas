### ————————————————————————————————————————————————————————————————————————————
### This module implements date utilities.

(defn date
  ```
  Builds the date struct.
  ```
  [year month day]
  {:year year :month month :day day})

(defn parse
  ```
  Builds the date struct from a string.
  ```
  [date-string]
  (date (splice (map scan-number (string/split "-" date-string)))))

(defn today
  ```
  Returns today's day in the following format:

  {:year 2021 :month 12 :day 31}
  ```
  []
  (let [today (os/date)]
    @{:year (today :year)
      :month (+ (today :month) 1)
      :day (+ (today :month-day) 1)}))
