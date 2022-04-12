### ————————————————————————————————————————————————————————————————————————————––––––––––––––––––––
### This module implements the list contacts command.

(import ../date :as d)
(import ../contact/repository :as contacts_repository)

(defn- to-csv-line [contact]
  (def last-contact (if (contact :last-contact) (d/format (contact :last-contact) true)))
  (string (contact :name) "," (contact :birthday) "," last-contact))

## —————————————————————————————————————————————————————————————————————————————––––––––––––––––––––
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
          error (load-result :error)]
      (if error
        {:errors [(string "--list-contacts " (string/ascii-lower error))]}
        {}))
    {}))
