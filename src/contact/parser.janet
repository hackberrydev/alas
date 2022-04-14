### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a PEG parser that parses a contact as a string into entities.

(import ../date :as d)
(import ../contact)

(def contact-grammar
  ~{:main (replace (* :name
                      (any :detail)
                      (? "\n")
                      (? (* (constant :last-contact) :last-contact)))
                   ,contact/build-contact)
    :name (* "# " (replace (capture (some (+ :w+ :s+))) ,string/trim))
    :detail (+ :category :birthday :other-detail)
    :category (* "- Category: " (constant :category) (capture (+ "A" "a" "B" "b" "C" "c" "D" "d")) "\n")
    :birthday (* "- Birthday: " (constant :birthday) (capture (* :d :d "-" :d :d)) "\n")
    :other-detail (* "- " :w+ ": " (some (+ :w+ " ")) "\n")
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
