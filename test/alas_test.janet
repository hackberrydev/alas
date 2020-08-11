(import tester :prefix "")
(import src/alas :as "alas")

(deftest
  (test "hello world test"
    (= (alas/hello-world) "hello world")))
