### ————————————————————————————————————————————————————————————————————————————
### This module implements date utilities.

(defn- prepend-with-0
  [s]
  (if (= 1 (length s))
    (string "0" s)
    s))


## —————————————————————————————————————————————————————————————————————————————
## Public interface

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

(defn format
  ```
  Formats date in ISO 8601 format. E.g 2021-09-30.
  ```
  [date]
  (def year (string (date :year)))
  (def month (prepend-with-0 (string (date :month))))
  (def day (prepend-with-0 (string (date :day))))
  (string/format "%s-%s-%s" year month day))

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
