(use judge)

(import ../src/date :as d)
(import ../src/task)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-task
(deftest "builds a new task"
  (def date (d/date 2022 7 15))
  (def task (task/build-task "Weekly meeting" false))
  (test (task :title) "Weekly meeting")
  (test (task :done) false))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test mark-as-missed

(deftest "marks task as missed"
  (def date (d/date 2022 7 15))
  (def task (task/build-task "Weekly meeting" false))
  (def new-task (task/mark-as-missed task date))
  (test (new-task :title) "Weekly meeting")
  (test (= (new-task :missed-on) date) true))
