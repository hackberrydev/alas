(defn- process-line [days line]
  (if (string/find "## " line)
    (array/push days @{:date (string/slice line 3) :tasks (array)}))
  (if (string/find "- [" line)
    (let [day (array/peek days)
          tasks (day :tasks)]
      (array/push tasks line)))
  days)

(defn read-lines
  ```
  Read lines from the file on the file path.
  Returns a struct:

    {:lines lines}   - When the file was successfully read.
    {:error message} - When the file was not successfully read.

  ```
  [path]
  (if (= (os/stat path) nil)
    {:error "File does not exist."}
    (let [file (file/read (file/open path) :all)
          lines (string/split "\n" file)]
      {:lines lines})))

(defn read-schedule
  ```
  Read a schedule from a file.
  Returs a struct:

    {:days [
      {:date "2020-08-01" :tasks ["- [  ] Develop photos" "- [ ] Pay bills"]}
      {:date "2020-07-31" :tasks ["- [  ] Review bugs"]}
    ]}

  Or an error struct:

    {:error message} - When the file was not successfully read.
  ```
  [path]
  (let [result (read-lines path)]
    (if (result :error)
      result
      {:days (reduce process-line (array) (result :lines))})))
