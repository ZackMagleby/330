#lang racket

(define (curry2 func)
  (lambda (x)
    (lambda (y)
      (func x y))))

(define (between temp1 temp2 tempCheck)
  (if (and (< temp1 tempCheck) (> temp2 tempCheck))
      true
      false))

(define (check-temps1 temps)
  (andmap (lambda (x) (between 5 95 x)) temps))

(define (check-temps temps low high)
  (andmap (lambda (x) (between low high x)) temps))

(define (convert digits)
  (foldr (
          lambda (x y)
           (+ x (* 10 y))) 0 digits)) ;;stumped

(define (duple lst)
  (map (lambda (x) (list x x)) lst))


(define (sum lst)
  (foldr + 0 lst))

(define (average lst)
  (if (empty? lst)
      0
      (/ (sum lst) (length lst))))

(define (convertFC temps)
   (map (lambda (x) (* (- x 32) (/ 5 9))) temps))

(define (eliminate-larger lst)
  (foldr (lambda (x y)
           (if (andmap (lambda (z) (>= z x)) y)
           (cons x y)
           y)) '() lst))