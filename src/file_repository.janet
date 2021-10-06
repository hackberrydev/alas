##——————————————————————————————————————————————————————————————————————————————
## This module implements the file repository.

(import ./entities :as e)

(defn- day-title? [line] (string/find "## " line))

(defn- task? [line] (string/find "- [" line))

(defn- add-new-day [days line]
  (array/push days (e/build-day (string/slice line 3) 0)))

(defn- add-new-task [day line]
  (array/push (day :tasks) line))

(defn- process-line [days line]
  (if (day-title? line)
    (add-new-day days line))
  (if (task? line)
    (add-new-task (array/peek days) line))
  days)

# ——————————————————————————————————————————————————————————————————————————————
# Public interface.

(defn write-lines
  ```
  Write lines to the file on the file path.
  ```
  [lines path]
  (let [file (file/open path :w)]
    (file/write file (string/join lines "\n"))
    (file/close file)))

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
    {:todo (file/read (file/open path) :all)}))
