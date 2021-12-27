### ————————————————————————————————————————————————————————————————————————————
### This module implements commands runner.

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn version
  ```
  Output version information. Returns the plan.
  ```
  [plan]
  (print "Alas version 0.1")
  plan)

(defn run-commands [plan commands-and-arguments]
  (reduce (fn [new-plan command-and-arguments]
            (def command (first command-and-arguments))
            (def arguments (drop 1 command-and-arguments))
            (apply command new-plan arguments))
          plan
          commands-and-arguments))
