(clear)

(gain 0.7)

(hint-ignore-depth)
(hint-depth-sort)


(define s
  (with-state
    (hint-unlit)
    (build-sphere 20 20)))

(define p-count
  (with-primitive s
    (poly-convert-to-indexed)
    (recalc-normals 0)
    (hide 1)
    (pdata-size)))

;(define t (load-texture "bubbles.png"))
;(texture t)
;(define pl 
;  (with-state
;    (colour #(1 0.7))
;    (scale #(4 4 4))
;    (build-plane)))
;(texture 0)

(define p (build-particles p-count))

(with-primitive p
  (pdata-map! 
    (lambda (c) #(0.1 0.2 0.7 .4))
    "c")
  (pdata-add "v" "v"))

(define lines (build-list p-count (lambda (x) (build-ribbon 8))))

(define boom
  (with-primitive s
    (for ([i (in-range p-count)])
      (let ((v (pdata-ref "p" i))
            (n (pdata-ref "n" i)))
        (with-primitive p
          (pdata-set! "p" i v)
          (pdata-set! "v" i (vmul n (* 0.015 (crndf)))))))))

(for-each
  (lambda (l)
    (with-primitive l
      (hint-none)
      (hint-wire)
      (hint-unlit)
      (hint-ignore-depth)
      (hint-anti-alias)
      (line-width 8)))
  lines)

(define animate
  (lambda ()  

    (let ((clr (* 0.2 (gh 3))))
    (with-primitive p
      (pdata-map! 
        (lambda (c)
          (let ((a (* 0.1 (gh 8))))
             (vector (rndf) clr 0 a)))
        "c")

      (pdata-map!
        (lambda (v)
          (vmul (hsrndvec) (* (gh 6) 0.01)))
        "v")

      (rotate (vector (* 1. (gh 1)) 0 0))
      (apply-transform)
      (pdata-op "+" "p" "v")

      (for ((i (in-range p-count)))
        (let ((v0 (pdata-ref "p" i))
              (v1 (pdata-op "closest" "p" i))
              (line (list-ref lines i)))
           (with-primitive line
              (for ((ix (in-range 8)))
                (pdata-set! "p" ix (vmix v0 (vmix (vector 0 0 1) v1 (* ix (* (gh 3) 0.3 0.125))) (* ix 0.2125)))
                (wire-colour (vector 0.8 0.2))))))))))


(every-frame (animate))

