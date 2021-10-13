(import testament :prefix "" :exit true)
(import ../../src/commands/stats :as "stats")

(def todo
  [{:date "2020-08-01"
    :tasks @[{:title "Develop photos for the grandmother" :done false}
             {:title "Pay bills" :done true}]}
   {:date "2020-07-31"
    :tasks @[{:title "Review open pull requests" :done true}
             {:title "Fix flaky test" :done true}]}])

(def stats (stats/stats todo))

(deftest days-stats
  (is (= 2 (stats :days))))

(deftest completed-tasks-stats
  (is (= 3 (stats :completed-tasks))))

(deftest pending-tasks-stats
  (is (= 1 (stats :pending-tasks))))

(deftest formatted-stats
  (is (= (stats/formatted-stats todo)
         "2 days\n3 completed tasks\n1 pending task")))

(run-tests!)
