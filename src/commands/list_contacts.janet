### ————————————————————————————————————————————————————————————————————————————––––––––––––––––––––
### This module implements the list contacts command.

(import ../date :as d)

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
    {}
    {}))
