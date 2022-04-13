(import testament :prefix "" :exit true)
(import ../../src/contact/parser :prefix "")
(import ../../src/date :as d)

## ————————————————————————————————————————————————————————————————————————————–––––––––––––––––––––
## Test parse

(deftest parse-contact
  (def contact-string
    ```
    # John Doe

    - Type: Contact
    - Category: A
    - Birthday: 04-23

    ## 2022-02-15

    Talked over the phone about stuff.

    ## 2022-01-28

    Grabbed a beer and talked about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (is (= "John Doe" (contact :name)))
  (is (= :a (contact :category)))
  (is (= "04-23" (contact :birthday)))
  (is (= (d/date 2022 2 15) (contact :last-contact))))

(deftest parse-contact-without-details
  (def contact-string
    ```
    # John Doe

    - Type: contact

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (is (= "John Doe" (contact :name)))
  (is (= (d/date 2022 2 19) (contact :last-contact))))

(deftest parse-contact-with-extra-details
  (def contact-string
    ```
    # John Doe

    - Type: Contact
    - Spouse: Jane Doe

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (is (= "John Doe" (contact :name)))
  (is (= (d/date 2022 2 19) (contact :last-contact))))

(deftest parse-object-that-is-not-contact
  (def contact-string
    ```
    # John Doe

    - Type: Relative

    ## 2022-02-19

    Talked over the phone about stuff.
    ```)
  (def contact ((parse contact-string) :contact))
  (is (nil? contact)))

(run-tests!)
