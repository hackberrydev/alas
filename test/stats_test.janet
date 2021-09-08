(import tester :prefix "" :exit true)
(import ../src/stats :as "stats")

(def schedule
  [{:date "2020-08-01"
    :tasks @["- [ ] Develop photos for the grandmother" "- [X] Pay bills"] }
   {:date "2020-07-31"
    :tasks @["- [X] Review open pull requests" "- [X] Fix flaky test"] } ])

(print "Test stats/schedule-stats")
(deftest
  (let [stats (stats/schedule-stats schedule)]
    (test "Days stats"
          (is (= 2 (stats :days))))
    (test "Completed tasks stats"
          (is (= 3 (stats :completed-tasks))))
    (test "Pending tasks stats"
          (is (= 1 (stats :pending-tasks))))))
