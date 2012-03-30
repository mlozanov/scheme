(require scheme/math)
(require scheme/class)

(clear)

(collisions 1)
(set-max-physical 100)

(gravity (vector 0 -1 0))

(define ground
  (ground-plane (vector 0 1 0) -3))

(define elem%
  (class object%
    (init id_)

    (field (id id_))

    (define c (build-cube))
    (with-primitive c
      (translate (hsrndvec)))
    (active-box c)

    

    (define/public (update)
      (with-primitive c
        (opacity (rndf))))

    (super-new)))

(define the-list (build-list 64 (lambda (x) (make-object elem% x))))

(define render
  (lambda ()
    (for-each 
      (lambda (r)
        (send r update))
      the-list)))

(every-frame (render))