#lang racket

(define (degrees-to-radians angle) (* (/ angle 180.0) pi.f))

(define (new-sin angle type)
  (cond [(symbol=? type 'degrees) (sin (degrees-to-radians angle))]
        [(symbol=? type 'radians) (sin angle)]))
;;
;;
;;

(define (default-parms f values)
  (lambda args
    (apply f
           (foldr
            (lambda (x y)
              (cons x y))
            args (list-tail values (length args))))))

(define (type-parms f values)
  (lambda args
    (if (and (andmap (lambda (x y) (x y)) values args) (eq? (length values) (length args)))
        (apply f args)
        (error "invalid type"))))

(define new-sin2 (default-parms 
  (type-parms
    new-sin
    (list number? symbol?))
   (list 0 'radians)))



;; sample function
(define (f x y z)
  ;(printf "Parameters are ~a, ~a, and ~a~n" x y z) ; for demonstration
  (+ x y z))

;; make a version with default parameter filling
(define g (default-parms f (list 0 1 2)))

;; and use it
(g 5)

;; a sample function
(define (sum-coins pennies nickels dimes quarters)
  (+ (*  1 pennies)
     (*  5 nickels)
     (* 10 dimes)
     (* 25 quarters)))

;; a composite type predicate
(define (positive-number? n)
  (and (number? n)
       (positive? n)))

;; make the typed version of the function
(define typed-sum-coins
  (type-parms sum-coins
              (list
               positive-number?
               positive-number?
               positive-number?
               positive-number?)))

;; using the typed version of the function correctly
(typed-sum-coins 1 2 3 4)
(with-handlers ([exn:fail? (lambda (e) (println "got an error"))]) (typed-sum-coins -1 2 3 4))

;; the chaining test for the assignment
(define (round-n num place)
  (let ((power (expt 10 place)))
    (/ (round (* power num)) power)))
(round-n (new-sin2 45 'degrees) 3)
(round-n (new-sin2 pi 'radians) 3)
