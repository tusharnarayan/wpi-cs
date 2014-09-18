;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 10-06) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;; ticketnum: number
;; remembers the last ticket number pulled from the machine
(define ticketnum 0)

;; get-ticket: -> number
;; produces the next ticket number
;; EFFECT: changes ticketnum
(define (get-ticket)
  (begin 
    (cond [(= ticketnum 4) (set! ticketnum 1)]
          [else (set! ticketnum (+ 1 ticketnum))])
    ticketnum))


;; use begin when we have more than one value being given out

;; an account is a
;; (make-account number number)
(define-struct account (acctnum amt))

;; a list-of-account is one of
;;  empty
;;  (cons account list-of-account)

;; Citibank: list-of-account
;; remembers the info about all the bank accounts
(define Citibank (list (make-account 1 500)
                       (make-account 2 50)
                       (make-account 3 10)))

;; remove-account: number -> void
;; removes the account with the given account number
;; EFFECT: changes Citibank
(define (remove-account acc-num)
  (set! Citibank (remove-from-list acc-num Citibank)))

;; hint: need to write a helper function
;; remove-from-list: number list-of-account -> list-of-account
;; removes the account with the given account number from the list
(define (remove-from-list acc-num aloa)
  (cond [(empty? aloa) (error "no such account")]
        [(cons? aloa)
         (cond [(= acc-num (account-acctnum (first aloa))) (rest aloa)]
               [else (cons (first aloa) (remove-from-list acc-num (rest aloa)))])]))

;; now we can't use check-expect since we get DIFFERENT results every run of the program
;; the results cannot be predicted, since they depend on how many times we run the program

;; error takes a string that is the error message you want displayed.



;; NEW EXAMPLE - state variables, set!, begin, local, maybe error too. IMPORTANT

;; model a simple vending machine
;; candy and soda, put coins in and dispense items

;; vending machine

;; constants
(define soda-cost 50)
(define candy-cost 65)

;; state-variable
;; amt: number
;; represents the current amount of cents in the vending machine
(define amt 0)

;; insert-coin: number -> void
;; adds the given number of cents to the vending machine
;; EFFECT: changes amt
(define (insert-coin cents)
  (set! amt (+ amt cents)))

;; choose-item: symbol -> string
;; consumes the item the user wants and produces a status message
(define (choose-item item)
  (cond [(symbol=? item 'soda)
         (cond [(>= amt soda-cost) "give soda"]
               [else "need more money"])]
        [(symbol=? item 'candy)
         (cond [(>= amt candy-cost) "give candy"]
               [else "need more money"])]))