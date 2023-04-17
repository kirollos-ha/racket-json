#lang racket

(define json-string "{\"massacre\" : \"the\", \"new\" : [\"american\", \"dream\", \"generation\"], \"ho\" : {\"litigato\" : \"con\", \"mia\" : \"moglie\"}}")

(define null-extraction #\u0000)
(define (null-extraction? c) (char=? c null-extraction))

(define (string-nexter str)
  (let ((index 0)
        (len (string-length str)))
    (define (ref)
      (if (> index len)
          (string-ref str index)
          null-extraction))
    (define (advance)
      (set! index (+ index 1)))
    (define (dispatch instruction)
      (cond ((eq? instruction 'ref) (ref))
            ((eq? instruction 'advance) (advance))
            (else
             (error "fuck you, I won't do what you told me! --STRING-NEXTER" instruction))))
    dispatch))

(define (str-to-numlist str)
  (define nexter (string-nexter str))
  (define (next-token)
    (let ((c (nexter 'ref)))
      (cond ((null-extraction? c) (print "ok fatto"))
            ((char-whitespace? c) (nexter 'advance) (next-token))
            ((char-numeric? c) (print "Quattr'occhi") (print (next-number)))
            (else (error "Kitammuort" (nexter 'ref))))))
  (define (next-number)
    (define (aug-number num dig)
      (+ (* 10 num)
         (char->integer dig)))
    (define (next-number-rec n)
      (let ((c (nexter 'ref)))
        (if (char-numeric? c)
            (begin
              (nexter 'advance)
              (next-number-rec (aug-number n c)))
            n)))
    (next-number-rec 0))
  (next-token))

(define numbers-in-string "15 11 2 12345 666 1")

    
