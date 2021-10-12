###—————————————————————————————————————————————————————————————————————————————
### This module implements the file repository.

## —————————————————————————————————————————————————————————————————————————————
## Public interface

(defn save-todo
  ```
  Save todo to supplied path.
  ```
  [todo path]
  (def copy-path (string path ".copy"))
  (let [file (file/open copy-path :w)]
    (file/write file todo)
    (file/close file))
  (if (os/stat path)
    (os/rm path))
  (os/rename copy-path path))

(defn load-todo
  ```
  Read todo from the file on the file path.
  Returns a struct:

    {todo todo-string} - When the file was successfully read.
    {:error message}   - When the file was not successfully read.

  ```
  [path]
  (if (= (os/stat path) nil)
    {:error "File does not exist"}
    {:todo (string (file/read (file/open path) :all))}))
