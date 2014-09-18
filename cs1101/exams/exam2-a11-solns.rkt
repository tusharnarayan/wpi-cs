;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-advanced-reader.ss" "lang")((modname exam2-a11-solns) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #t #t none #f ())))
;; a boa is a 
;;   (make-boa string number string)
(define-struct boa (name length food))
;; where name is the name of the boa, length is the boa's length in inches,
;; and food is the boa's favorite food

;; a dillo is a 
;;   (make-dillo number boolean)
(define-struct dillo (length dead?))
;; where length is the dillo's length in inches, and dead? is true if
;; the boa is dead, false otherwise

;; a tiger is a 
;;   (make-tiger string number number)
(define-struct tiger (name length weight))
;; where name is the tiger's name, length is its length in inches, and
;; weight is its weight in pounds

;; an animal is one of
;;    boa
;;    dillo
;;    tiger

;; a list-of-animal is one of
;;   empty
;;   (cons animal list-of-animal)

;; 1a)
(define animals (list (make-boa "Danny" 22 "pigs")       ;; 3 points each
                      (make-dillo 4 true)                ;;     boa
                      (make-tiger "Ralph" 55 130)))      ;;     dillo
                                                         ;;     tiger
                                                         ;; used list/cons correctly - 1 point






;; 1b).

;; TEMPLATE FOR A UNION REQUIRES A COND WITH A RECOGNIZER FOR EACH ITEM IN THE UNION

;; gentle-animal?:  animal -> boolean                                         ;; follows template:
;; consumes an animal and produces true if the animal is a dead dillo, or a   ;;    cond with 3 questions - 6 points
;; boa of length 20 inches or less whose favorite food is vegetables.         ;;    answers to questions correct - 3 points each
;; The function produces false otherwise.
(define (gentle-animal? an-ani)
  (cond [(boa? an-ani) (gentle-boa? an-ani)]
        [(dillo? an-ani) (dillo-dead? an-ani)]
        [(tiger? an-ani) false]))

;; gentle-boa?:  boa -> boolean
;; consumes a boa and returns true if it is less than or = 20 inches and eats vegetables
(define (gentle-boa? a-boa)
  (and (<= (boa-length a-boa) 20)
       (string=? "vegetables" (boa-food a-boa))))

;; 1c).

;; gentle-animals:  list-of-animal -> list-of-animal                           ;; follows template:
;; consumes a list of animals and produces a list of those animals that        ;;     cond with 2 questions, 
;;   - are dead dillos                                                         ;;     pulls out first/(gentle-animals (rest...)) - 5 points
;;   - are boas of length 20 inches or less whose favorite food is vegetables  ;; answers correct in each case
(define (gentle-animals aloa)                                                  ;;     empty for empty?  - 2 points
  (cond [(empty? aloa) empty]                                                  ;;     another cond in cons? case - 2 points
        [(cons? aloa)                                                          ;;     cond question - 2 points
         (cond [(gentle-animal? (first aloa))                                  ;;     answer if yes - 2 points
                (cons (first aloa) (gentle-animals (rest aloa)))]              ;;     answer if no - 2 points
               [else (gentle-animals (rest aloa))])]))





;; Problem 2

;; a foo is one of
;;   "stop"
;;   false
;;   person

;; a person is a 
;;    (make-person string number foo)
(define-struct person (name age more))

;; 2a)                              ;; make-person with 3 parts - 5 points
                                    ;; types of each part correct
(make-person "Glynis" 21 "stop")    ;;      string - 1 pt
                                    ;;      number - 1 pt
                                    ;;      foo - 3 points

;; 2b)

;;  TWO DATA DEFINITIONS REQUIRES TWO TEMPLATES

;;; foo-fcn:  foo ... -> ...                        ;; cond with 3 questions - 3 points
;;; ...                                             ;; questions are recognizers - 3 points
;(define (foo-fcn a-foo ...)                        ;; call to person template - 3 points
;  (cond [(string? a-foo)      ]                    ;; contract/purpose - 2 pts
;        [(boolean?  a-foo)    ]
;        [(person? a-foo)  (person-fcn a-foo)]))
;
;;; person-fcn:  person ... -> ...   ;; selectors correctly named - 2 pts
;;; ...                              ;; selectors correctly called - 2 pts
;(define (person-fcn a-per ...)      ;; foo template applied to person-more - 3 pts
;  (person-name a-per)               ;; contract/purpose - 2 pts
;  (person-age a-per)
;  (foo-fcn (person-more a-per)))


;; 3).

;; DESCENDANT TREE PROBLEM REQUIRES TWO FUNCTIONS

;; an employee is a struct
;;  (make-employee string string list-of-employee)
(define-struct employee (name position subordinates))

;; a list-of-employee is one of                                                   
;;    empty
;;    (cons employee list-of-employee)

;; any-programmers?:  employee -> boolean                                     ;; template pulls out selectors - 2 pts
;; consumes an employee and produces true if anyone in the employee's tree    ;; template contains call to list function - 2 pts
;; has the position "programmer", otherwise produces false                    ;; question correct (string=?...) - 2 pts
(define (any-programmers? an-emp)                                             ;; yes answer correct - 2 pts  |
  (or (string=? "programmer" (employee-position an-emp))                      ;; no answer correct - 2 pts   |   OR, uses "or" correctly, 4 pts  
      (programmers-in-list? (employee-subordinates an-emp))))

;; programmers-in-list?:  list-of-employee -> boolean                         ;; contract - 3 pts
;; consumes a list of employees and produces true if any of the employees     ;; purpose - 1 pt
;; in the list have the position "programmer"                                 ;; template with empty?/cons? - 4 pts
(define (programmers-in-list? aloe)                                           ;; template calls correct functions on first/rest - 3 pts each (6)
  (cond [(empty? aloe) false]                                                 ;; answer correct for empty? - 2 pts
        [(cons? aloe) (or (any-programmers? (first aloe))                     ;; answer correct for cons? - 4 pts
                          (programmers-in-list? (rest aloe)))]))