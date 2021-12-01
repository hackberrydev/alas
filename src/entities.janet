### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

(defn build-day [date &opt events tasks]
  (default events @[])
  (default tasks @[])
  {:date date :events events :tasks tasks})

(defn build-task [title done]
  {:title title :done done})

(defn build-event [text]
  {:text text})
