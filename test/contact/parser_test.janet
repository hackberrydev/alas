(use judge)

(import ../../src/contact/parser :prefix "")
(import ../../src/date :as d)

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Test parse

(deftest "parses contacts"
  (def contact-string
    ```
    # John Doe

    - Category: A
    - Birthday: 04-23

    ## 2022-02-15

    Talked over the phone about stuff.

    ## 2022-01-28

    Grabbed a beer and talked about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "John Doe")
  (test (contact :category) :a)
  (test (contact :birthday) "04-23")
  (test (= (d/date 2022 2 15) (contact :last-contact)) true))

(deftest "parses contacts without details"
  (def contact-string
    ```
    # John Doe

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "John Doe")
  (test (= (d/date 2022 2 19) (contact :last-contact)) true))

(deftest "parses contacts with extra details"
  (def contact-string
    ```
    # John Doe

    - Spouse: Jane Doe

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "John Doe")
  (test (= (d/date 2022 2 19) (contact :last-contact)) true))

(deftest "parses contacts with non ASCII characters in the name"
  (def contact-string
    ```
    # Petar Petrović

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "Petar Petrović"))

(deftest "parses contacts with non ASCII characters in extra details"
  (def contact-string
    ```
    # John Doe

    - Spouse: Jane Doić

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "John Doe")
  (test (= (d/date 2022 2 19) (contact :last-contact)) true))

(deftest "parses contacts with ID in the name line"
  (def contact-string
    ```
    # 202201081224 John Doe

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (test (contact :name) "John Doe")
  (test (= (d/date 2022 2 19) (contact :last-contact)) true))
