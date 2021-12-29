### ————————————————————————————————————————————————————————————————————————————
### This module implements backup command.

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn backup [plan plan-path]
  (def backup-path (string plan-path ".bkp"))
  (let [plan-file (file/open plan-path :r)
        backup-file (file/open backup-path :w)]
    (file/write backup-file (file/read plan-file :all))
    (file/close plan-file)
    (file/close backup-file))
  (print "Created backup.")
  plan)
