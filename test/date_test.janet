(import tester :prefix "" :exit true)
(import ../src/date :as date)

(print "Test date/today")
(deftest
  (test "Date structure"
        (let [today (date/today)]
          (is (today :year))
          (is (today :month))
          (is (today :day)))))
