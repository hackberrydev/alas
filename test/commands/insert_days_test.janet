(import testament :prefix "" :exit true)
(import ../../src/entities :as "e")
(import ../../src/date :as "d")
(import ../../src/commands/insert_days :as "c")

(deftest insert-day-at-top
  (def todo @[(e/build-day (d/date 2020 8 3) 3)
              (e/build-day (d/date 2020 8 2) 6)])
  (def new-todo (c/insert-days todo (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-1 (first new-todo))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 4) (day-1 :date)))
  (is (= 3 (day-1 :line-number)))
  (is (day-1 :changed)))

(deftest insert-three-days-at-top
  (def todo @[(e/build-day (d/date 2020 8 3) 3)
              (e/build-day (d/date 2020 8 2) 6)])
  (def new-todo (c/insert-days todo (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-1 (first new-todo))
  (is (= 5 (length new-todo)))
  (is (= (d/date 2020 8 6) (day-1 :date)))
  (is (= 3 (day-1 :line-number)))
  (is (day-1 :changed)))

(deftest insert-days-in-middle
  (def todo @[(e/build-day (d/date 2020 8 6) 3)
              (e/build-day (d/date 2020 8 2) 6)])
  (def new-todo (c/insert-days todo (d/date 2020 8 4) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 4 (length new-todo)))
  (is (= (d/date 2020 8 4) (day-2 :date)))
  (is (= 6 (day-2 :line-number))))

(deftest insert-days-when-today-already-exists
  (def todo @[(e/build-day (d/date 2020 8 6) 3)
              (e/build-day (d/date 2020 8 4) 6)])
  (def new-todo (c/insert-days todo (d/date 2020 8 6) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 5) (day-2 :date)))
  (is (= 6 (day-2 :line-number))))

(deftest insert-days-with-empty-todo
  (def todo (c/insert-days @[] (d/date 2020 8 4) (d/date 2020 8 4)))
  (is (= 1 (length todo)))
  (is (= (d/date 2020 8 4) ((first todo) :date)))
  (is (= 1 ((first todo) :line-number))))

(deftest insert-days-with-one-day-in-future
  (print "Test insert-days-with-one-day-in-future")
  (def todo @[(e/build-day (d/date 2020 8 6) 3)])
  (def new-todo (c/insert-days todo (d/date 2020 8 5) (d/date 2020 8 4)))
  (def day-2 (new-todo 1))
  (is (= 3 (length new-todo)))
  (is (= (d/date 2020 8 5) (day-2 :date)))
  (is (= 3 (day-2 :line-number))))

(run-tests!)
