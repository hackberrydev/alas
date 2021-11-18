(import testament :prefix "" :exit true)
(import ../../src/entities :as "e")
(import ../../src/date :as "d")
(import ../../src/commands/insert_days :as "c")

(deftest insert-day-at-top
  (def todo @[(e/build-day (d/date 2020 8 3))
              (e/build-day (d/date 2020 8 2))])
  (def new-todo (c/insert-days todo (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-1 (first new-todo))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 4) (day-1 :date))))

(deftest insert-three-days-at-top
  (def todo @[(e/build-day (d/date 2020 8 3))
              (e/build-day (d/date 2020 8 2))])
  (def new-todo (c/insert-days todo (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-1 (first new-todo))
  (is (= 5 (length new-todo)))
  (is (= (d/date 2020 8 6) (day-1 :date))))

(deftest insert-days-in-middle
  (def todo @[(e/build-day (d/date 2020 8 6))
              (e/build-day (d/date 2020 8 2))])
  (def new-todo (c/insert-days todo (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 4 (length new-todo)))
  (is (= (d/date 2020 8 4) (day-2 :date))))

(deftest insert-days-when-today-already-exists
  (def todo @[(e/build-day (d/date 2020 8 6))
              (e/build-day (d/date 2020 8 4))])
  (def new-todo (c/insert-days todo (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 5) (day-2 :date))))

(deftest insert-days-with-empty-todo
  (def todo (c/insert-days @[] (d/date 2020 8 4) (d/date 2020 8 4)))
  (is (= 1 (length todo)))
  (is (= (d/date 2020 8 4) ((first todo) :date))))

(deftest insert-days-with-one-day-in-future
  (print "Test insert-days-with-one-day-in-future")
  (def todo @[(e/build-day (d/date 2020 8 6))])
  (def new-todo (c/insert-days todo (d/date 2020 8 5) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 5) (day-2 :date))))

(run-tests!)
