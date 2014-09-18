;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname sampleexam3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;; Sample Exam 3

;; Problem 1

;; a truck is a (make-truck number number string)
(define-struct truck (mpg odometer license))

;; examples of a truck
(define truck1 (make-truck 12 4590 "APG"))
(define truck2 (make-truck 19 7809 "XYD"))
(define truck3 (make-truck 25 1892 "BGF"))
(define truck4 (make-truck 10 3402 "FGH"))

;; list-of-truck is either
;; empty, or
;; (cons truck list-of-truck)

;; examples of a list-of-truck
(define sample-list1 (list truck1 truck2))
(define sample-list2 (list truck3 truck4))
(define sample-list3 (append sample-list1 sample-list2))

;; higher-mileage-trucks: list-of-truck number -> list-of-string
;; consumes a list of trucks and a number that represents an odometer reading.
;; The function produces a list of the license plate numbers of those
;; trucks in the list that have an odometer reading greater than the
;; given value.

(define (higher-mileage-trucks alot odometer-reading)
  (local [(define (higher-mileage-in-list a-truck)
            (cond [(> (truck-odometer a-truck) odometer-reading)
                   true]
                  [else false]))]
    (map truck-license (filter higher-mileage-in-list alot))))

;; test cases
(check-expect (higher-mileage-trucks sample-list1 10000)
              empty)
(check-expect (higher-mileage-trucks sample-list1 5000)
              (list "XYD"))
(check-expect (higher-mileage-trucks sample-list2 1000)
              (list "BGF" "FGH"))
(check-expect (higher-mileage-trucks sample-list3 4000)
              (list "APG" "XYD"))

;; Problem 2
;; least-efficient-truck: list-of-truck[non-empty] -> truck
;; consumes a non-empty list of trucks and returns the truck from the list that
;; has the lowest mpg.
(define (least-efficient-truck alot)
(least-efficient-accum (rest alot) (first alot)))

;; least-efficient-accum: list-of-truck truck -> truck
;; consumes a list of trucks and returns the truck with the lowest mpg from the
;; list, using an accumulator
(define (least-efficient-accum alot truck-accum)
  (cond [(empty? alot) truck-accum]
        [(cons? alot)
         (cond [(< (truck-mpg (first alot)) (truck-mpg truck-accum))
                (least-efficient-accum (rest alot) (first alot))]
               [else (least-efficient-accum (rest alot) truck-accum)])]))

;; test cases
(check-expect (least-efficient-truck sample-list1)
              (make-truck 12 4590 "APG"))
(check-expect (least-efficient-truck sample-list2)
              (make-truck 10 3402 "FGH"))
(check-expect (least-efficient-truck sample-list3)
              (make-truck 10 3402 "FGH"))

;; Problem 3

;; a faculty-member (fm) is a struct
;; (make-fm string list-of-committee)
(define-struct fm (name committees))

;; a committee is a struct
;; (make-committee string list-of-fm)
(define-struct committee (name members))

;; a list-of-fm is either
;; empty, or
;; (cons fm list-of-fm)

;; a list-of-committee is either
;; empty, or
;; (cons committee list-of-committee)

(define Bill (make-fm "Bill" empty))
(define Anita (make-fm "Anita" empty))

(define Policy (make-committee "Policy" empty))
(define Undergrad (make-committee "Undergrad" empty))
(define Facilities (make-committee "Facilities" empty))

;; Part a
(set-fm-committees! Bill (list Undergrad Policy))
(set-fm-committees! Anita (list Facilities Policy))
(set-committee-members! Policy (list Anita Bill))
(set-committee-members! Undergrad (list Bill))
(set-committee-members! Facilities (list Anita))

;; Part b
;; fm-on-committee: fm committee -> void
;; adds the given fm as a member of the given committee,
;; and adds the given committee to the list of committees
;; that the fm serves on
;; EFFECT: changes both faculty-member and committee
(define (fm-on-committee afm acommittee)
  (begin
    (set-committee-members! acommittee 
                            (cons afm (committee-members acommittee)))
    (set-fm-committees! afm
                        (cons acommittee (fm-committees afm)))))

;; Problem 4
;; balance: number
;; remembers a credit card balance
(define balance 500)

;; make-payment: number -> string
;; consumes the dollar amount to pay against the credit card balance, and
;; produces a string as described above
;; EFFECT: the amount of the given payment is subtracted from balance
(define (make-payment charge-amount)
    (format "You paid $~a on a $~a balance. Your new balance is $~a"
            charge-amount balance (begin (set! balance (- balance charge-amount)) balance)))