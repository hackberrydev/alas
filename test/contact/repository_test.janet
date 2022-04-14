(import testament :prefix "" :exit true)
(import ../../src/contact/repository :prefix "")

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test load-contacts

(deftest load-contacts-from-directory
  (def path (os/realpath "test/examples/contacts"))
  (def contacts ((load-contacts path) :contacts))
  (is (= 2 (length contacts)))
  (is (= "Jane Doe" ((contacts 0) :name)))
  (is (= "John Doe" ((contacts 1) :name))))

(deftest load-contacts-when-directory-does-not-exist
  (def result (load-contacts "test/missing-directory"))
  (is (= "Directory does not exist." (result :error))))

(run-tests!)
