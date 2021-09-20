(import testament :prefix "" :exit true)
(import ../utils :as "test")
(import ../../src/commands/insert_date :prefix "")

(def example-file "test/examples/todo.md")

(deftest insert-date-at-top
  (do
    (test/backup-file example-file)
    (insert-date "## 2020-08-02, Sunday" example-file)
    (is (=
         (string/join
           ["# Main TODO\n"
            "## 2020-08-02, Sunday\n"
            "## 2020-08-01, Saturday\n"
            "- [ ] Develop photos for the grandmother"
            "- [X] Pay bills\n"
            "## 2020-07-31, Friday\n"
            "- [X] Review open pull requests"
            "- [X] Fix flaky test\n"]
           "\n")
         (string (file/read (file/open example-file) :all))))
    (test/restore-file example-file)))

(run-tests!)
