(import testament :prefix "" :exit true)

(import ../src/date :as d)
(import ../src/task)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test mark-as-missed

(deftest mark-as-missed
  (def date (d/date 2022 7 15))
  (def task (task/build-task "Weekly meeting" false))
  (def new-task (task/mark-as-missed task date))
  (is (= "Weekly meeting" (task :title)))
  (is (= "Weekly meeting" (new-task :title)))
  (is (= date (new-task :missed-on))))

(run-tests!)
