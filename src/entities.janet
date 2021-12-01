### ————————————————————————————————————————————————————————————————————————————
### This module implements all entities and related functions.

(defn build-plan [title inbox-tasks days]
  {:title title :inbox inbox-tasks :days days})

(defn build-day [date &opt tasks]
  (default tasks @[])
  {:date date :tasks tasks})

(defn build-task [title done]
  {:title title :done done})

(defn build-event [text]
  {:text text})
