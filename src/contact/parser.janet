### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses a contact as a string into entities.

(import ../date :as d)
(import ../contact)

(def contact-grammar
  ~{:main (replace (* :name
                      (? "\n")
                      (any :detail)
                      (? "\n")
                      (? (* (constant :last-contact) :last-contact)))
                   ,contact/build-contact)
    :name (* "# " (replace (capture (some (if-not "\n" 1))) ,string/trim) "\n")
    :detail (+ :category :birthday :other-detail)
    :category (* "- Category: " (constant :category) (capture (+ "A" "a" "B" "b" "C" "c" "D" "d")) "\n")
    :birthday (* "- Birthday: " (constant :birthday) (capture (* :d :d "-" :d :d)) "\n")
    :other-detail (* "- " (some (if-not ":" 1)) ": " (some (if-not "\n" 1)) "\n")
    :last-contact (* "## " (replace :date ,d/parse))
    :date (capture (* :d :d :d :d "-" :d :d "-" :d :d))})

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn parse
  ```
  Parses a string and returns a contact entity.
  ```
  [contact-string]
  (def parse-result (peg/match contact-grammar contact-string))
  {:contact (first parse-result)})
