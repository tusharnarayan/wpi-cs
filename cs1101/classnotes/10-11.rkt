;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname 10-11) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;; a webpage is a (make-webpage string list-of-webpage)
(define-struct webpage (url links))

;; a list-of-webpage is either
;; empty, or
;; (cons webpage list-of-webpage)

(define Ghome (make-webpage "www.cs.wpi.edu/~ghamel" empty))
(define 1101home (make-webpage "www.cs.wpi.edu/~cs1101" empty))
(define CShome (make-webpage "www.cs.wpi.edu" empty))

;; add-link: webpage webpage -> void
;; adds a link from the first page to the second page
(define (add-link firstpage secondpage)
  (set-webpage-links! firstpage (cons secondpage (webpage-links firstpage))))

(add-link Ghome 1101home)
(add-link 1101home Ghome)
(add-link CShome Ghome)

;; count-pages: webpage  -> number
;; counts the number of pages accessible from this page
;; EFFECT: sets visited to empty
(define (count-pages apage)
  (begin (set! visited empty)
         (page-counter apage)))

;; page-counter: webpage -> number
;; counts the number of pages accessible from this page
;; EFFECT: updates visited
(define (page-counter apage)
  (cond [(member? (webpage-url apage) visited) 0]
        [else (begin 
                (set! visited (cons (webpage-url apage) visited))
                (+ 1 (count-links (webpage-links apage))))])) ;; + 1 done here for the page itself!

;; count-links: list-of-webpage -> number
;; counts the number of pages accessible from every page in the list
(define (count-links alop)
  (cond [(empty? alop) 0]
        [(cons? alop) (+ (page-counter (first alop)) 
                         (count-links (rest alop)))]))

;; infinte loop since the webpages are referencing each other!!!
;; to get around this, we create a state variable to keep track of what we've counted already

;; visited: list-of-string
;; remembers the urls of the pages that have already been visited
(define visited empty)