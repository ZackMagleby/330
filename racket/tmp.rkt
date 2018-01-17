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

;;(define (duple lst)
;;  (if (equal? (length lst) 1)
;;      (cons (first lst) (first lst))
;;      (list (duple (first lst)) (duple (rest lst)))))

(define (duple lst) 0)

(define (sum lst)
  (if (empty? lst)
      0
      (+ (first lst) (sum (rest lst)))))

(define (average lst)
  (if (empty? lst)
      0
      (/ (sum lst) (length lst))))

(define (convertFC temps) 0)

(define (eliminate-larger lst) 0)

;;(define (at-function lst iterator n)
;;  (if (equal? iterator n)
;;      (first lst)
;;      (at-function (rest lst) (+ iterator 1) n)))

(define (get-nth lst n) 0)

;;(define (get-nth lst n)
;; (at-function lst 0 n))

(define (find-item lst target) 0)

(check-temps1 (list 80 92 56))
(check-temps1 (list 80 99 56))
(check-temps (list 80 92 56) 5 95)
(check-temps (list 80 99 56) 5 95)
(convert (list 1 2 3))
(duple (list 1 2 3))
(average (list 1 2 3 4))
(convertFC (list 32 50 212))
(eliminate-larger (list 1 2 3 9 4 5))
(get-nth (list 1 2 3 4) 2)
(find-item (list 1 2 3 4) 3)
(find-item (list 1 2 3 4) 42)
