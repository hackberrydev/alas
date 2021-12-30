### ————————————————————————————————————————————————————————————————————————————
### This module implements backup command.

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
  [file-path date])

(defn backup [plan plan-path]
  (def backup-path (string plan-path ".bkp"))
  (let [plan-file (file/open plan-path :r)
        backup-file (file/open backup-path :w)]
    (file/write backup-file (file/read plan-file :all))
    (file/close plan-file)
    (file/close backup-file))
  (print "Created backup.")
  plan)
