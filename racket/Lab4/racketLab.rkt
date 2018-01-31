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