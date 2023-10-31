### ————————————————————————————————————————————————————————————————————————————————————————————————
### Errors.

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(def exit-status-codes
  {:error 1
   :plan-path-missing 2
   :file-error 3
   :parse-error 4
   :command-error 5})

(defn format-command-errors [command errors]
  (map (fn [error] (string command " " (string/ascii-lower error) ".")) errors))

# TODO: This function should go away.
(defn print-errors-without-status-code [errors]
  (loop [error :in errors]
    (print error)))

(defn print-errors [errors exit-status-code]
  (each error errors (print (string error ".")))
  (os/exit exit-status-code))
