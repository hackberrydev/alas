## —————————————————————————————————————————————————————————————————————————————
## This module implements date utilities.

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