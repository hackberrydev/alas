(import ../file_repository :as "file-repository")
(import ../stats :as "stats")

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
  (let [result (file-repository/load-todo file-path)
        todo (result :days)
        error-message (result :error)]
      (or error-message
          (format-stats (stats/schedule-stats todo)))))

(defn insert-date
  ```
  Inserts the date to the correct location in the file.
  ```
  [date file-path]
  (let [schedule (file-repository/read-lines file-path)
        lines (schedule :lines)]
    (or (schedule :error)
        (do
          (array/insert (schedule :lines) 2 (string date "\n"))
          (file-repository/write-lines lines file-path)))))