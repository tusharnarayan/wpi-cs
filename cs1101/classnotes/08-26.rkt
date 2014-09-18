;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname 08-26) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
(define moon-gravity .1667)

;; weight-on-moon: number -> number                                                          (CONTRACT)
;; consumes the weight of an object on the earth and produces its weight on the moon         (PURPOSE)

(define (weight-on-moon earth-weight)
  (* earth-weight moon-gravity))   ; computation

;; moon-weight-with-backpack: number number -> number
;; consumes the weights of a person and a backpack on the earth and produces their combined weight on the moon

(define (moon-weight-with-backpack person-earth-weight backpack-earth-weight)
  (+ (weight-on-moon person-earth-weight) (weight-on-moon backpack-earth-weight)))
