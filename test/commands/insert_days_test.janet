(import testament :prefix "" :exit true)
(import ../../src/entities :as "e")
(import ../../src/date :as "d")
(import ../../src/commands/insert_days :as "c")

(deftest insert-days-at-top
  (def today (d/date 2020 8 4))
  (def todo @[(e/build-day (d/date 2020 8 3) 3)
              (e/build-day (d/date 2020 8 2) 6)])
  (c/insert-days todo (d/date 2020 8 4) today)
  (def day-1 (first todo))
  (is (= 3 (length todo)))
  (is (= (d/date 2020 8 4) (day-1 :date)))
  (is (= 3 (day-1 :line-number)))
  (is (day-1 :changed)))

(run-tests!)
