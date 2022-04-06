### ————————————————————————————————————————————————————————————————————————————
### This module implements a repository that loads contacts from Markdown files.

(import ../file_repository)
(import ./parser :as contact_parser)

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load-contacts [path]
  (def abs-path (os/realpath path))
  (filter
    identity
    (map
      (fn [contact-path]
        (def text ((file_repository/load (string abs-path "/" contact-path)) :text))
        (if text
          ((contact_parser/parse text) :contact)))
      (os/dir abs-path))))
