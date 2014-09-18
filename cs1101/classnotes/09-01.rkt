;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 09-01) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; a boa is a struct                                        (DATA DEFINITION)
;; Here's how to make a boa:
;;  (make-boa string number string)
(define-struct boa (name length food))


;; Examples of boas
(define Jack (make-boa "Jack" 12 "beetles"))

;; boa-fit-cage?  : boa number -> boolean ;;convention to name a function that returns a boolean with a ? at the end
;; consumes a boa and the length of  a cage and produces true if
;; the length of the boa is less than the cage length, or produces
;; false otherwise
(define (boa-fit-cage? test-boa cage-length)
  (< (boa-length test-boa) cage-length))

; Another way:
;(define (boa-fit-cage? test-boa cage-length)
;(cond [(< (boa-length test-boa) cage-length) true]
;      [else false]))

;; you CAN define boas in interactions window

;; to check if the name of two boa's are is the same - (string=? (boa-name Jack) "jack") ;; would give false because of case

;; test-cases
(check-expect (boa-fit-cage? Jack 20) true)
(check-expect (boa-fit-cage? Jack 12) false)
(check-expect (boa-fit-cage? (make-boa "Homer" 10 "donuts") 3) false)