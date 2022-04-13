### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements the file repository.

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public interface

(defn save
  ```
  Save string to a file to the supplied path.
  ```
  [text path]
  (def copy-path (string path ".copy"))
  (let [file (file/open copy-path :w)]
    (file/write file text)
    (file/close file))
  (if (os/stat path)
    (os/rm path))
  (os/rename copy-path path))

(defn load
  ```
  Read a string from the file on the file path.
  Returns a struct:

    {:text string}   - When the file was successfully read.
    {:error message} - When the file was not successfully read.

  ```
  [path]
  (if (= (os/stat path) nil)
    {:error "File does not exist."}
    {:text (string (file/read (file/open path) :all))}))
