;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 08-29) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; wages: number number -> number
;; consumes an hourly salary and the number of hours worked and 
;; produces the weekly pay (assume at least 40 hours)
(define (wages salary hours)
  (+ (* 40 salary) (* (- hours 40) (* salary 1.5)))
  )

;; tests
(check-expect (wages 10 40) 400)

;; single-pen-cost: number -> number
;; consumes the number of pens in an order and produces the cost of a single pen
(define (single-pen-cost num-pens)
  (cond [(<= num-pens 10) .75]
        [(> num-pens 10) .50])) ;; [else .50]))
(single-pen-cost 20) ;; for using the Stepper
;; tests
(check-expect (single-pen-cost 5) .75)
(check-expect (single-pen-cost 10) .75)
(check-expect (single-pen-cost 20) .50)


;; pen-order-cost: number -> number
;; consumes the number of pens in an order and produces the total cost of the order
(define (pen-order-cost num-pens)
  (* (single-pen-cost num-pens) num-pens))

;;tests
(check-expect (pen-order-cost 5) 3.75)
(check-expect (pen-order-cost 10) 7.50)
(check-expect (pen-order-cost 20) 10.00)
