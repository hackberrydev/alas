### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements various utilites.

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn pluralize [n word]
  (if (= n 1)
    (string n " " word)
    (string n " " word "s")))

(defn dirname [path]
  (if (string/has-suffix? "/" path)
    (string/trimr path "/")
    path))

(defn format-command-errors [command errors]
  (map (fn [error] (string command " " (string/ascii-lower error) ".")) errors))
