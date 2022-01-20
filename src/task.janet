### ————————————————————————————————————————————————————————————————————————————
### This module implements task entity and related functions.

(defn build-task [title done]
  {:title title :done done})

(defn build-scheduled-task [title schedule]
  {:title title :done false :schedule schedule})
