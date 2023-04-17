(define json-infix-obj
  '(object (("ipse"  : "dixit")
            ("count" : 10)
            ("list"  : (1 2 3 4))
            ("composite" : (object (("mother" : "fucker")
                                    ("esculapio" : "inculatio")
                                    ("altra lista" : ("tu" "eri" "chiara" "e" "trasparente" "come" "me"))))
                         ("print" : (lambda (x) (print x)))))))

;; idea 2, un oggetto è una lista che inizia con il simbolo 'object (più esplicito, ma un po' prolisso)
#|
poi avere object come car, così a cazzo è orrendo,
quindi potrebbe servire fare che l'oggetto non sia propio
il cdr della lista ('object <spec oggetto>) che mi fa (<spec oggetto>), ma più
il cadr della lista ('object (<spec oggetto>)) che fa (car ((<spec oggetto>))) che fa (<spec oggetto>)
da vedere
|#
(define (json--object? obj)
  (and (pair? obj)
       (eq? (car obj) 'object)))
