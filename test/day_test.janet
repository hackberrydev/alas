(import testament :prefix "" :exit true)
(import ../src/day)
(import ../src/date :as d)

(deftest generate-days
  (def days (day/generate-days (d/date 2020 8 2) (d/date 2020 8 5)))
  (is (= 4 (length days)))
  (is (= (d/date 2020 8 5) ((days 0) :date)))
  (is (= (d/date 2020 8 4) ((days 1) :date)))
  (is (= (d/date 2020 8 3) ((days 2) :date)))
  (is (= (d/date 2020 8 2) ((days 3) :date))))

(run-tests!)
