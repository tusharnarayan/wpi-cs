;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 09-26) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; sort: list-of-number -> list-of-number
;; produces the numbers in the list in sorted order
(define (sort alon)
  (cond [(empty? alon) empty]
        [(cons? alon) (insert (first alon)   ;; 3
                              (sort (rest alon))) ])) ;; (list 1 2 4)

;; test
(check-expect (sort empty) empty)
(check-expect (sort (list 3 4 2 1)) (list 1 2 3 4))

;; insert: number list-of-number(sorted) -> list-of-number (sorted)
;; consumes a number and a sorted list and produces a sorted list
;; with the number inserted in the correct place
(define (insert num aslon)
  (cond [(empty? aslon) (cons num empty)]
        [(cons? aslon) (cond [(< num (first aslon)) (cons num aslon)]
                             [else (cons (first aslon) (insert num (rest aslon)))])]))

;; test
(check-expect (insert 4 (list 1 2 6)) (list 1 2 4 6))
(check-expect (insert 4 empty) (list 4))
;; required test cases - 
;; greater than all, less than all, somewhere in middle
;; what about when the number already in there!?

;; THIS IS NOT ON THE EXAM
;; binary search trees are not on the exam
;; mututally recursive trees will definitely come!

;; a person is a struct
;; (make-person string number symbol list-of-person)
(define-struct person (name year eye children))

;; a list-of-person is one of
;;    empty
;;    (cons person list-of-person)
;; three arrows here - recursive data definitions

(define SusanTree
  (make-person "Susan" 1920 'blue
               (list (make-person "Joe" 1938 'green empty)
                     (make-person "Helen" 1940 'brown
                                  (list (make-person "Hank" 1965 'green empty)
                                        (make-person "Cara" 1969 'brown empty)))
                     (make-person "Ricky" 1942 'blue empty))))

;; people-with-kids: person -> list-of-string
;; produces the names of all the people in the tree who have children
(define (people-with-kids per)
  (cond [(cons? (person-children per)) (cons (person-name per) (kids-with-kids (person-children per)))]
        [else empty]))

;; kids-with-kids: list-of-person -> list-of-string
;; produces a list of the names of people who have children
(define (kids-with-kids alop)
  (cond [(empty? alop) empty]
        [(cons? alop) (append
                       (people-with-kids (first alop))
                      (kids-with-kids (rest alop)))]))

;; test case
(check-expect (people-with-kids SusanTree)(list "Susan" "Helen"))