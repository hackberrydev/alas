###—————————————————————————————————————————————————————————————————————————————
### This module implements the file repository.

## —————————————————————————————————————————————————————————————————————————————
## Public interface

(defn save-plan
  ```
  Save plan to supplied path.
  ```
  [plan path]
  (def copy-path (string path ".copy"))
  (let [file (file/open copy-path :w)]
    (file/write file plan)
    (file/close file))
  (if (os/stat path)
    (os/rm path))
  (os/rename copy-path path))

(defn load-plan
  ```
  Read plan from the file on the file path.
  Returns a struct:

    {:plan plan-string} - When the file was successfully read.
    {:error message}   - When the file was not successfully read.

  ```
  [path]
  (if (= (os/stat path) nil)
    {:error "File does not exist"}
    {:plan (string (file/read (file/open path) :all))}))
