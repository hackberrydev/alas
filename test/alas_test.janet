(import tester :prefix "")
(import alas)

(deftest
  (test "hello world test"
    (= (alas/hello-world) "hello world")))
