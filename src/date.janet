### ————————————————————————————————————————————————————————————————————————————––––––––––––––––––––
### This module implements date utilities.

(def seconds-in-day (* 60 60 24))

(defn- prepend-with-0
  [s]
  (if (= 1 (length s))
    (string "0" s)
    s))

(defn- week-day-string
  [week-day]
  (case week-day
        0 "Sunday"
        1 "Monday"
        2 "Tuesday"
        3 "Wednesday"
        4 "Thursday"
        5 "Friday"
        6 "Saturday"))

(defn- week-day [date-struct]
  (week-day-string ((os/date (os/mktime date-struct)) :week-day)))

(defn- to-os-date-struct
  ```
  Turns an Alas date struct into the Janet date struct.
  ```
  [date]
  {:year (date :year)
   :month (- (date :month) 1)
   :month-day (- (date :day) 1)})

(defn- from-os-date-struct
  [date]
  {:year (date :year)
   :month (+ 1 (date :month))
   :day (+ 1 (date :month-day))
   :week-day (week-day date)})

## ————————————————————————————————————————————————————————————————————————————–––––––––––––––––––––
## Public interface

(defn to-time [date]
  (os/mktime (to-os-date-struct date)))

(defn date
  ```
  Builds the date struct.
  ```
  [year month day]
  (def date-struct {:year year :month (- month 1) :month-day (- day 1)})
  {:year year :month month :day day :week-day (week-day date-struct)})

(defn parse
  ```
  Builds the date struct from a string.
  ```
  [date-string]
  (date (splice (map scan-number (string/split "-" date-string)))))

(defn format
  ```
  Formats date in ISO 8601 format. E.g '2021-12-30, Thursday'.
  ```
  [date &opt skip-week-day]
  (default skip-week-day false)
  (def year (string (date :year)))
  (def month (prepend-with-0 (string (date :month))))
  (def day (prepend-with-0 (string (date :day))))
  (if skip-week-day
    (string/format "%s-%s-%s" year month day)
    (string/format "%s-%s-%s, %s" year month day (date :week-day))))

(defn today
  ```
  Returns today's day in the following format:

  {:year 2021 :month 12 :day 31 :week-day "Friday"}
  ```
  []
  (let [today (os/date)]
    @{:year (today :year)
      :month (+ (today :month) 1)
      :day (+ (today :month-day) 1)
      :week-day (week-day-string (today :week-day))}))

(defn +days [date n]
  (def new-date-time (+ (to-time date) (* n seconds-in-day)))
  (from-os-date-struct (os/date new-date-time)))

(defn -days [date n]
  (def new-date-time (- (to-time date) (* n seconds-in-day)))
  (from-os-date-struct (os/date new-date-time)))

(defn days-from-now [n]
  (+days (today) n))

(defn equal?
  [d1 d2]
  (= (to-time d1) (to-time d2)))

(defn before?
  ```
  Returns true if d1 is before d2.
  ```
  [d1 d2]
  (< (to-time d1) (to-time d2)))

(defn before-or-eq?
  [d1 d2]
  (<= (to-time d1) (to-time d2)))

(defn after?
  ```
  Returns true if d1 is after d2.
  ```
  [d1 d2]
  (> (to-time d1) (to-time d2)))

(defn after-or-eq?
 [d1 d2]
 (>= (to-time d1) (to-time d2)))

(defn last-day-of-month?
  ```
  Returns true if the date is the last day of a month.
  ```
  [date]
  (def tomorrow (+days date 1))
  (not= (date :month) (tomorrow :month)))

(defn last-friday-of-month?
  ```
  Returns true if the date is the last friday of a month.
  ```
  [date]
  (def next-week (+days date 7))
  (and (= (date :week-day) "Friday")
       (not= (date :month) (next-week :month))))
