(declare-project
  :name "janet"
  :description "A command line utility for planing your days"
  :dependencies [{:repo "https://github.com/pyrmont/testament"}
                 {:url "https://github.com/ianthehenry/judge.git" :tag "v2.6.1"}
                 {:repo "https://github.com/janet-lang/argparse"}])

(declare-executable
 :name "alas"
 :entry "src/alas.janet")
