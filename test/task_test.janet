(use judge)

(import ../src/date :as d)
(import ../src/task)

(def date (d/date 2022 7 15))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-task
(deftest "builds a new task"
  (def task (task/build-task "Weekly meeting" false))
  (test (task :title) "Weekly meeting")
  (test (task :done) false)
  (test (task :state) :open))

(deftest "sets the correct state for tasks that are done"
  (def task (task/build-task "Weekly meeting" true))
  (test (task :state) :checked))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-scheduled-task
(deftest "builds a new scheduled task"
  (def task (task/build-scheduled-task 15 "Weekly meeting" "every Tuesday"))
  (test (task :title) "Weekly meeting")
  (test (task :done) false)
  (test (task :state) :open))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test build-missed-task
(deftest "builds a new missed task"
  (def task (task/build-missed-task "Weekly meeting" date))
  (test (task :title) "Weekly meeting")
  (test (task :done) false)
  (test (d/equal? (task :missed-on) date) true)
  (test (task :state) :open))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test mark-as-missed

(deftest "marks task as missed"
  (def task (task/build-task "Weekly meeting" false))
  (def new-task (task/mark-as-missed task date))
  (test (new-task :title) "Weekly meeting")
  (test (= (new-task :missed-on) date) true))
