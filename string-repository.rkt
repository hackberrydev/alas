#lang racket

(require gregor
         "entities.rkt")

(define (day-title day)
  (string-append "## " (~t (day-date day) "y-MM-dd, EEEE") "\n"))

(define (day-title? line) (string-prefix? line "## "))

(define (build-day line line-number)
  (day (iso8601->date (substring line 3 13))
       (list)
       line-number
       #f))

(define (parse todo)
  (let parse-line ([todo-lines (string-split todo "\n")]
                   [days (list)]
                   [line-number 0])
    (if (empty? todo-lines)
      (reverse days)
      (let ([line (first todo-lines)]
            [todo-lines (rest todo-lines)]
            [line-number (+ line-number 1)])
        (cond
          [(day-title? line) (parse-line
                               todo-lines
                               (cons (build-day line line-number) days)
                               line-number)]
          [else (parse-line todo-lines days line-number)])))))

(define (serialize days todo)
  (define (insert-day? day current-line)
    (= (day-line-number day) current-line))
  (let insert-days ([days days]
                    [todo-lines (string-split todo "\n")]
                    [new-todo-lines (list)]
                    [current-line 0])
    (if (empty? todo-lines)
      (string-join (reverse new-todo-lines) "\n")
      (let ([current-line (+ current-line 1)]
            [day (first days)]
            [line (first todo-lines)]
            [todo-lines (rest todo-lines)])
        (if (insert-day? day current-line)
          (insert-days (rest days)
                       todo-lines
                       (append (list line (day-title day)) new-todo-lines)
                       current-line)
          (insert-days days
                       todo-lines
                       (cons line new-todo-lines)
                       current-line))))))

(module+ test
  (require rackunit)

  (test-case
    "day-title"
    (check-equal?
      (day-title (day (date 2021 6 21) '() 1 false))
      "## 2021-06-21, Monday\n"))

  (test-case
    "parse"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [days (parse todo)]
           [day-1 (list-ref days 0)]
           [day-2 (list-ref days 1)])
      (check-equal? (length days) 2)
      (check-equal? (day-date day-1) (date 2020 8 1))
      (check-equal? (day-line-number day-1) 3)
      (check-false (day-changed day-1))
      (check-equal? (day-date day-2) (date 2020 7 31))
      (check-equal? (day-line-number day-2) 8)
      (check-false (day-changed day-2))))

  (test-case
    "serialize"
    (let* ([todo (string-append "# Main TODO\n\n"
                                "## 2020-08-01, Saturday\n\n"
                                "- [ ] Develop photos\n"
                                "- [x] Pay bills\n\n"
                                "## 2020-07-31, Friday\n\n"
                                "- [x] Review open pull requests\n"
                                "- [x] Fix the flaky test")]
           [days (list (day (date 2020 8 2) (list) 3 #t) )])
      (check-equal? (serialize days todo)
                    (string-append "# Main TODO\n\n"
                                   "## 2020-08-02, Sunday\n\n"
                                   "## 2020-08-01, Saturday\n\n"
                                   "- [ ] Develop photos\n"
                                   "- [x] Pay bills\n\n"
                                   "## 2020-07-31, Friday\n\n"
                                   "- [x] Review open pull requests\n"
                                   "- [x] Fix the flaky test")))))
