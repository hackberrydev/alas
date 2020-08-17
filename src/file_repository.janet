(defn read-file
  ```
  Read a file from the file path.
  Returns a struct:

    {:lines lines}   - When the file was successfully read.
    {:error message} - When the file was not successfully read.

  ```
  [path]
  (let [file (file/read (file/open path) :all)
        lines (string/split "\n" file)]
    {:lines lines}))
