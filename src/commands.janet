(import src/file_repository :as "file-repository")
(import src/stats :as "stats")

(defn- pluralize [n word]
  (if (= n 1)
    (string n " " word)
    (string n " " word "s")))

(defn- format-stats [stats]
  (string/join
    @[(pluralize (stats :days) "day")
      (pluralize (stats :completed-tasks) "completed task")
      (pluralize (stats :pending-tasks) "pending task")]
    "\n"))

(defn stats
  ```
  It returns stats for the TODO file.
  ```
  [file-path]
  (let [result (file-repository/read-schedule file-path)]
    (format-stats (stats/schedule-stats (result :days)))))
