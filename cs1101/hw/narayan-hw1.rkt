;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname narayan-hw1) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ())))
;; Name            : Tushar Narayan
;; CC Username     : tnarayan

(require 2htdp/image)

;; Solution to Problem 1, using constant 'TRAFFIC-LIGHT-REGULAR' to denote the symbol of a traffic light formed by 3 circles

;; TRAFFIC-LIGHT-REGULAR: no arguments -> image
;; consumes no arguments, and produces an image of a regular traffic light
(define TRAFFIC-LIGHT-REGULAR
  (underlay/offset (circle 25 "solid" "red")
                  0 75
                  (underlay/offset (circle 25 "solid" "yellow")
                  0 50
                  (circle 25 "solid" "green"))))


;; Solution to Problem 2, modifying function TRAFFIC-LIGHT-REGULAR so that the colors can be user-defined

;; using a helper function - signal : string -> image
;; consumes a string representing the color of the light, and produces the image of that particular light
;;  NOTE - this task delegated to helper function since it makes for easier understanding of code, and 
;;  also since if we need to change the size or fill-attribute of the lights, we need only change the 
;;  code in the helper function once, and it will be reflected in all the three lights of the traffic signal
(define (signal traffic-light-level)
  (circle 25 "solid" traffic-light-level))

;; MAIN FUNCTION - traffic-light:  string string string -> image
;; consumes three strings representing the colors of the top, middle, and
;; bottom lights and produces an image of a traffic light in those colors
;; (by calling the helper function to produce an image of the three individual components
;;  and then putting them together to form a traffic signal)
(define (traffic-light top middle bottom)
  (underlay/offset (signal top)
                  0 75
                  (underlay/offset (signal middle)
                  0 50
                  (signal bottom))))


;; Solution to Problem 3, a cleaner version of the provided code for producing bar graphs for three pieces of data
;; First we define the helper functions and the constants used, and then the main function.

;; Constant 1 - bar-width : number
;; specfies how wide each bar should be in the bar graph
;; used in drawing the bar for each data value (Helper Function 3)
;; defined as a constant since it is relative to the area of the graph background rectangle; easier to change
;; the value of a constant once (than changing the value everywhere its used in the program, if we want to
;; make the graph bigger or smaller
(define bar-width 15)

;; Constant 2 - height-multiplier : number
;; number that is used in calculations to scale the height of the bar so that the 
;; bars fit in the background image appropriately
;; used in drawing the bar for each data value; sets the scale appropriate to the background of the graph (Helper Function 2)
;; defined as a constant for ease of change in future if the scale of graph needs to be changed
(define height-multiplier 3)

;; Constant 3 - vertical-spacer : number
;; number that is used in calculations to determine the space for offsetting the bars
;; used in determining the distance between each bar of the graph (Helper Function 1)
;; defined as a constant for ease of change of scale in future
(define vertical-spacer 40)

;; Helper Function 1 - vertical-space-calculator : number -> number
;; consumes one number (the data of the bar) and produces the value of how much vertical space should be used in
;; the underlay/offset function so that the graphs are uniformly aligned
(define (vertical-space-calculator data)
  (- vertical-spacer (* 1/2 (bar-height-calculator data))))

;;  NOTE - we are not delegating the task of calculating the horizontal space for the bars to another helper
;;  function, since it would only lead to a couple of extra calculations without adding much to the
;;  understandibility of the code

;; Helper Function 2 - bar-height-calculator : number -> number
;; consumes one number (the data of the bar) and produces the value of how high the bar should be in the graph
(define (bar-height-calculator data)
  (* height-multiplier data))

;; Helper Function 3 - bar-graph-creator : number string -> image
;; consumes a number and a string, and produces an image of the bar-graph on the basis of the number, and colors
;; the graph according to the color in the string
(define (bar-graph-creator data color)
  (rectangle bar-width (bar-height-calculator data) "solid" color))

;; MAIN FUNCTION
;; bar-graph : number number number -> image
;; consumes three numbers and produces bar graph of results
;;   NOTE: background image sized for inputs up to 20
(define (bar-graph num-a num-b num-c)
  (underlay/offset (underlay/offset (underlay/offset (rectangle 80 80 "solid" "tan")
                                      -25 (vertical-space-calculator num-a)
                                      (bar-graph-creator num-a "red"))
                          0 (vertical-space-calculator num-b)
                          (bar-graph-creator num-b "blue"))
              25 (vertical-space-calculator num-c)
              (bar-graph-creator num-c "green")))


;; Solution to Problem 4, evaluating the given DrRacket program
;; Question:
;; (define (double n) (* n 2))
;; (/ (- (* 9 3) (double 6)) 2)

;; Solution:
;;  (/ (- (* 9 3) (double 6)) 2)
;;        ^^^^^^^
;; = (/ (- 27 (double 6)) 2)
;;            ^^^^^^^^^^
;; = (/ (- 27 (* 6 2)) 2)
;;            ^^^^^^^
;; = (/ (- 27 12) 2)
;;      ^^^^^^^^^
;; = (/ 15 2)
;;   ^^^^^^^^
;; = 7.5