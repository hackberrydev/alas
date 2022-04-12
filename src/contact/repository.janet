### ————————————————————————————————————————————————————————————————————————————
### This module implements a repository that loads contacts from Markdown files.

(import ../file_repository)
(import ./parser :as contact_parser)

(defn load-contact [contact-path]
  (def text ((file_repository/load contact-path) :text))
  (if text
   ((contact_parser/parse text) :contact)))

## —————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load-contacts [path]
  (if (os/stat path)
    (let [abs-path (os/realpath path)
          contacts (filter
                     identity
                     (map
                       (fn [contact-file] (load-contact (string abs-path "/" contact-file)))
                       (os/dir abs-path)))]
      {:contacts contacts})
    {:error "Directory does not exist."}))
