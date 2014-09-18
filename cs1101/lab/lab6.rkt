;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname lab6) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Tushar Narayan
;; tnarayan

;; Lab 6

;; Data definitions

;; A Radio Show is a (make-rs string number list-of-ad)
(define-struct rs (name minutes ads))

;; An ad is a (make-ad string number number)
(define-struct ad (name minutes profit))

;; a list-of-ad is either
;; empty, or
;; (cons ad list-of-ad)

;; Examples of data:

(define ipod-ad (make-ad "ipod" 2 100))
(define ms-ad (make-ad "ms" 1 500))
(define xbox-ad (make-ad "xbox" 2 300))

(define news-ads (list ipod-ad ms-ad ipod-ad xbox-ad))
(define game-ads (list ipod-ad ms-ad ipod-ad ms-ad xbox-ad ipod-ad))
(define bad-ads (list ipod-ad ms-ad ms-ad ipod-ad xbox-ad ipod-ad))

(define news (make-rs "news" 60 news-ads))
(define game (make-rs "game" 120 game-ads))



;; compute the total time for all ads in the given list
;; total-time: list-of-ad -> number 
(define (total-time adlist)
  (cond
    [(empty? adlist) 0]
    [(cons? adlist) (+ (ad-minutes (first adlist))
                       (total-time (rest adlist)))]))

(check-expect (total-time news-ads) 7)
(check-expect (total-time game-ads) 10)

;; total-time-acc: list-of-ad -> number 
(define (total-time-acc adlist )
  (total-time-acc-version adlist 0))

;; total-time-acc-version: list-of-ad number -> number
(define (total-time-acc-version adlist ad-accum)
  (cond [(empty? adlist) ad-accum]
        [(cons? adlist) 
         (total-time-acc-version (rest adlist) 
                                 (+ (ad-minutes (first adlist)) ad-accum))]))

(check-expect (total-time-acc news-ads) 7)
(check-expect (total-time-acc game-ads) 10)
(check-expect (total-time-acc empty) 0)

;; total-profit-acc: rs -> number
(define (total-profit-acc a-rs)
  (total-profit-acc-version (rs-ads a-rs) 0))

;; total-profit-acc-version: list-of-ad number -> number
(define (total-profit-acc-version adlist profit-accum)
  (cond [(empty? adlist) profit-accum]
        [(cons? adlist)
         (total-profit-acc-version (rest adlist)
                                   (+ (ad-profit (first adlist)) profit-accum))]))

(check-expect (total-profit-acc news) 1000)
(check-expect (total-profit-acc game) 1600)
(check-expect (total-profit-acc-version empty 0) 0)

;; no-repeat-acc: list-of-ads -> boolean
(define (no-repeat adlist)
  (no-repeat-acc-version adlist true))

;; no-repeat-acc-version: list-of-ads boolean -> boolean
(define (no-repeat-acc-version adlist a-accum)
  (cond [(empty? adlist) a-accum]
        [(cons? adlist) 
         (cond [(empty? (rest adlist)) true]
               [(cons?  (rest adlist))
                (cond [(string=? (ad-name (first adlist))
                                 (ad-name (first (rest adlist))))
                       false]
                      [else (no-repeat-acc-version (rest adlist) true)])])]))

(check-expect (no-repeat game-ads) true)
(check-expect (no-repeat bad-ads) false)
(check-expect (no-repeat empty) true)

;; an accumulator was needed in the above function to store the value of the boolean
;; obtained by comparing every group of two ads in the list of ads