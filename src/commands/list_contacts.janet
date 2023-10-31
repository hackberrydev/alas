### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements the list contacts command.

(import ../utils :prefix "")
(import ../date :as d)
(import ../errors)
(import ../contact/repository :as contacts_repository)

(defn- to-csv-line [contact]
  (def last-contact (if (contact :last-contact)
                      (d/format (contact :last-contact) true)))
  (string (contact :name) ","
          (contact :category) ","
          (contact :birthday) ","
          last-contact))

(defn- print-contacts [plan contacts]
  (print "Name,Category,Birthday,Last Contact")
  (loop [contact :in contacts]
    (print (to-csv-line contact)))
  plan)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn list-contacts
  ```
  Returns array of strings that represent the CSV lines, separated by commas.
  ```
  [contacts]
  (map to-csv-line contacts))

(defn build-command [arguments &]
  (def argument (arguments "list-contacts"))
  (if argument
    (let [load-result (contacts_repository/load-contacts argument)
          errors (load-result :errors)]
      (if errors
        {:errors (errors/format-command-errors "--list-contacts" errors)}
        {:command [print-contacts (load-result :contacts)]}))
    {}))
