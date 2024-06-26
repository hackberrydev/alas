### ————————————————————————————————————————————————————————————————————————————————————————————————
### Errors.

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(def exit-status-codes
  {:ok 0
   :error 1
   :plan-path-missing 2
   :file-error 3
   :parse-error 4
   :command-error 5})

(def no-error [[] (exit-status-codes :ok)])

(defn format-command-errors [command errors]
  (map (fn [error] (string command " " (string/ascii-lower error))) errors))

(defn print-errors [errors exit-status-code]
  (each error errors (print (string error ".")))
  (os/exit exit-status-code))
