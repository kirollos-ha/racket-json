#lang racket

#|
qui voglio fare un modo per prendere liste propiamente formattate in lisp
e tradurle in json

poi si inizierà a lavorare in direzione opposta
quando ne avrò voglia

come esempio di come voglio fare sto vi presento la cavia
|#
(define json-infix
  '(
    ("ipse"  : "dixit")
    ("count" : 10)
    ("list"  : (1 2 3 4))
    ("composite" : (
                    ("mother" : "fucker")
                    ("esculapio" : "inculatio")
                    ("altra lista" : ("tu" "eri" "chiara" "e" "trasparente" "come" "me"))
                    ))
    ("print" : (lambda (x) (print x))))
  )

;; per traudrre una sintassi json in lisp iniziamo dalle coppie <nome> : <valore>
;; qui faremo che un'associazione è una lista nella forma (<nome(stringa)> : <valore(boh)>)
(define (json-assoc? ass)
  (and (pair? ass)
       (string? (car ass))
       (not (null? (cdr ass)))
       (eq? (cadr ass) ':)))

(define (assoc-name ass) (car ass))
(define (assoc-value ass) (caddr ass))

;; un oggetto è una lista che inizia con una coppia nome-valore
(define (json-object? obj)
  (and (pair? obj)
       (json-assoc? (car obj))))

;; un array è una lista che non è un oggetto
(define (json-list? lst)
  (and (pair? lst)
       (not (json-assoc? (car lst)))))

(define (print-children json)
  (unless (null? json)
    (print-json (car json))
    (printf ",~%")
    (print-children (cdr json))))

(define (print-json j)
  (if (json-immediate? j)
      (print-json-immediate j)
      (print-json-composite j)))

(define (json-immediate? j)
  (or (number? j)
      (string? j)
      (eq? j 'true)
      (eq? j 'false)
      (eq? j 'null)))

(define (print-json-immediate j)
  (if (symbol? j)
      (printf "~A" (symbol->string j))
      (print j)))

(define (lambda-expr? l)
  (and (pair? l) (eq? (car l) 'lambda)))

#| currently assumes json object to be valid, shitty |#
(define (print-json-composite j)
  (cond ((json-assoc? j) (printf "\"~A\" : " (assoc-name j))
                         (print-json (assoc-value j)))
        ((lambda-expr? j) (print j))
        ((json-object? j)
         (printf "{~%") ; newline per formatting
         (print-children j)
         (printf "}~%")) ; newline per cominciare quello dopo da una riga sigola
        ((json-list? j)
         (printf "[~%")
         (print-children j)
         (printf "]~%"))))
