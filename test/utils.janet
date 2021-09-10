(defn backup-file
  ```
  Copies file to FILE_NAME.bkp.
  ```
  [file-path]
  (os/execute @["cp" file-path (string file-path ".bkp")] :p))

(defn restore-file
  ```
  Copies file from FILE_NAME.bkp to FILE_NAME and removes FILE_NAME.bkp.
  ```
  [file-path]
  (os/execute @["cp" (string file-path ".bkp") file-path] :p)
  (os/rm (string file-path ".bkp")))
