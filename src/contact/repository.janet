### ————————————————————————————————————————————————————————————————————————————————————————————————
### This module implements a repository that loads contacts from Markdown files.

(import ../utils)

(import ../file_repository)
(import ./parser :as contact_parser)

(defn- load-contact [contact-path]
  (def text ((file_repository/load contact-path) :text))
  (if text
   ((contact_parser/parse text) :contact)))

## —————————————————————————————————————————————————————————————————————————————————————————————————
## Public Interface

(defn load-contacts [path]
  (if (os/stat path)
    (let [directory (utils/dirname path)
          contacts (filter
                     identity
                     (map
                       (fn [contact-file] (load-contact (string directory "/" contact-file)))
                       (os/dir directory)))]
      {:contacts contacts})
    {:errors ["Directory does not exist"]}))
