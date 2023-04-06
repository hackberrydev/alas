(import testament :prefix "" :exit true)
(import ../../src/contact/repository :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test load-contacts

(deftest load-contacts-from-directory
  (def path (os/realpath "test/examples/contacts"))
  (def contacts ((load-contacts path) :contacts))
  (def names (sort (map (fn [contact] (contact :name)) contacts)))
  (is (= 2 (length contacts)))
  (is (= "Jane Doe" (names 0)))
  (is (= "John Doe" (names 1))))

(deftest load-contacts-when-directory-does-not-exist
  (def result (load-contacts "test/missing-directory"))
  (is (= "Directory does not exist" (first (result :errors)))))

(run-tests!)
