### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements task entity and related functions.

(defn build-task [title done &opt body]
  {:title title :body body :done done})

(defn build-scheduled-task [title schedule &opt body]
  {:title title :body body :done false :schedule schedule})
