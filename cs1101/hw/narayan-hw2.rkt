;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname narayan-hw2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Christina Aiello
;;
;; Tushar Narayan
;; tnarayan

(define-struct hotel-info (nights-needed hotel-rating room-type))

;;examples
(define Ritz (20 5 double))

(define-struct registrant (name category hotel-info attend-dinner?))

;; examples
(define Tushar ("Tushar Narayan" "student" Ritz true))

(define (registration-rate test-registrant)
  (cond [


