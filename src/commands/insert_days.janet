### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a command for inserting new days in a plan.

(import ../date)
(import ../plan)
(import ../day)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn insert-days
  ```
  Inserts new days into the plan.

  (insert-days plan date today)

  plan  - The plan entity.
  date  - The date up to which new days will be generated.
  today - Date.
  ```
  [plan date today]
  (plan/insert-days plan (day/generate-days today date)))

(defn build-command [arguments &]
  (def argument (arguments "insert-days"))
  (if argument
    (let [insert-days-count (parse argument)]
      (if (number? insert-days-count)
        {:command [insert-days
                   (date/days-from-now (- insert-days-count 1))
                   (date/today)]}
        {:errors ["--insert-days argument is not a number."]}))
    {}))
