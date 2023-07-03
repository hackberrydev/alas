(use judge)

(import ../../src/contact/repository :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test load-contacts

(deftest "loads contacts from a directory"
  (def path (os/realpath "test/examples/contacts"))
  (def contacts ((load-contacts path) :contacts))
  (def names (sort (map (fn [contact] (contact :name)) contacts)))
  (test (length contacts) 2)
  (test (names 0) "Jane Doe")
  (test (names 1) "John Doe"))

(deftest "returns an error when the directory doesn't exist"
  (def result (load-contacts "test/missing-directory"))
  (test (first (result :errors)) "Directory does not exist"))
