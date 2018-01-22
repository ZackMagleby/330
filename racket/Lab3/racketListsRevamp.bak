#lang racket

(define (between temp1 temp2 tempCheck)
  (if (and (< temp1 tempCheck) (> temp2 tempCheck))
      true
      false))

(define (check-temps1 temps)
  (if (empty? temps)
      true
      (and (between 5 95 (first temps)) (check-temps1 (rest temps)))))

(define (check-temps temps low high)
  (if (empty? temps)
      true
      (and (between low high (first temps)) (check-temps (rest temps) low high))))

(define (convert digits)
  (if (equal? (length digits) 1)
      (first digits)
      (+ (first digits) (* 10 (convert (rest digits))))))

(define (duple lst)
  (if (empty? lst)
      empty
      (cons (list (first lst) (first lst)) (duple (rest lst)))))


(define (sum lst)
  (if (empty? lst)
      0
      (+ (first lst) (sum (rest lst)))))

(define (average lst)
  (if (empty? lst)
      0
      (/ (sum lst) (length lst))))

(define (convertFC temps)
  (if (empty? temps)
      empty
      (cons (* (- (first temps) 32) (/ 5 9)) (convertFC (rest temps)))))

(define (eliminate-larger lst)
  (if (equal? (length lst) 1)
      lst
      (if (< (first lst) (first (rest lst)))
          (cons (first lst) (eliminate-larger (rest lst)))
          (eliminate-larger (rest lst)))))

(define (at-function lst iterator n)
  (if (equal? iterator n)
      (first lst)
      (at-function (rest lst) (+ iterator 1) n)))


(define (get-nth lst n)
 (at-function lst 0 n))

(define (contains-function lst iterator target)
  (if (empty? lst)
      -1
      (if (equal? (first lst) target)
          iterator
          (contains-function (rest lst) (+ iterator 1) target))))

(define (find-item lst target)
  (contains-function lst 0 target))