### ————————————————————————————————————————————————————————————————————————————
### This module implements backup command.

(import ../date)

(defn- split-path-to-segments [path]
  (def segments (string/split "." path))
  (if (= "" (segments 0))
    (put segments 0 "."))
  (if (= "" (segments 1))
    (put segments 1 "."))
  segments)

(defn- append-path-index
  [path index]
  (def path-segments (split-path-to-segments path))
  (string (apply string (array/slice path-segments 0 -2))
          "-"
          index
          "."
          (array/peek path-segments)))

(defn- append-backup-path-index
  ```
  If a file with the path exists, append an index to make the file path unique.
  ```
  [path]
  (var index 1)
  (var new-path path)
  (while (os/stat new-path)
    (set new-path (append-path-index path index))
    (set index (+ index 1)))
  new-path)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn backup-path
  ```
  Returns the backup path that includes the date.

  file-path - Path to the backup file.
  date      - Date to include in the backup file name (today).

  Example:

  (backup-path 'plan.md' (date 2020 8 1))
  > 'plan-2020-08-01.md'
  ```
  [file-path date]
  (def path-segments (split-path-to-segments file-path))
  (def path (string (apply string (array/slice path-segments 0 -2))
                   "-"
                   (date/format date true)
                   "."
                   (array/peek path-segments)))
  (append-backup-path-index path))

(defn backup [plan plan-path date]
  ```
  Creates a backup on a backup path created from plan-path.

  plan      - The plan.
  plan-path - The path where the plan is located. Used as a base for the backup
              path.
  date      - Today.
  ```
  (def plan-file (file/open plan-path :r))
  (def backup-file (file/open (backup-path plan-path date) :w))
  (file/write backup-file (file/read plan-file :all))
  (file/close plan-file)
  (file/close backup-file)
  (print "Created backup.")
  plan)

(defn build-command [arguments file-path]
  (if (arguments "skip-backup")
    {}
    {:command [backup file-path (date/today)]}))
