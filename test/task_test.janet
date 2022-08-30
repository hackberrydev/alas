(import testament :prefix "" :exit true)

(import ../src/date :as d)
(import ../src/task)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test mark-as-missed

(deftest mark-as-missed
  (def task (task/build-task "Weekly meeting" false))
  (def new-task (task/mark-as-missed task (d/date 2022 7 15)))
  (is (= "Weekly meeting" (task :title)))
  (is (= "Weekly meeting (missed on 2022-07-15)" (new-task :title))))

(run-tests!)
