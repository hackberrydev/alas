(import ../file_repository :as "file-repository")

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
