(declare-project
  :name "janet"
  :description "Command line utility for planing your days"
  :dependencies [{:repo "https://github.com/pyrmont/testament"}
                 {:repo "https://github.com/janet-lang/argparse"}])

(declare-executable
 :name "alas"
 :entry "src/alas.janet")
