(import testament :prefix "" :exit true)
(import ../src/stats :as stats)

(def schedule
  [{:date "2020-08-01"
    :tasks @["- [ ] Develop photos for the grandmother" "- [X] Pay bills"] }
   {:date "2020-07-31"
    :tasks @["- [X] Review open pull requests" "- [X] Fix flaky test"] } ])

(def stats (stats/schedule-stats schedule))

(deftest days-stats
  (is (= 2 (stats :days))))

(deftest completed-tasks-stats
  (is (= 3 (stats :completed-tasks))))

(deftest pending-tasns-stats
  (is (= 1 (stats :pending-tasks))))
