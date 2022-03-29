(import testament :prefix "" :exit true)
(import ../src/date :as d)
(import ../src/contact_parser)

## -----------------------------------------------------------------------------
## Test parse

(deftest parse-contact
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
  (def contact ((contact_parser/parse contact-string) :contact))
  (is (= "John Doe" (contact :name)))
  (is (= :a (contact :category)))
  (is (= "04-23" (contact :birthday)))
  (is (= (d/date 2022 2 15) (contact :last-contact))))

(run-tests!)
