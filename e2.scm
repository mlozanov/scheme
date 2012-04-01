;;(load "/Users/mlozanov/Documents/extempore/libs/dsp_library.scm")

(load "/Users/mlozanov/Documents/scheme/openglsetup.scm")
(load "/Users/mlozanov/Documents/scheme/primitives.scm")
(load "/Users/mlozanov/Documents/scheme/oscwrapper.scm")

(definec draw-grid
  (let ((width 8.0)
        (height 8.0)
        (i:i64 0)
        (j:i64 0)
        (a:double 0.0))
    (lambda (time:double z:double randomness:double)
      (set! a (+ a (* 2.0 (sin (* 0.0001 time)))))
      (dotimes (i 8)
        (dotimes (j 8)
          (glPushMatrix)
          (let ((x (* 0.1 (i64tod i)))
                (y (* 0.1 (i64tod j))))
            ;;(glTranslated (+ x (* (+ (_fader11) (* 0.6 (sin (* 0.0001 time)) (random))) x))
            ;;              y
            ;;              0.0)

            (glTranslated x y z)
            (glRotated a 0.0 1.0 0.0)
            
            (glColor3d (_xy-x) (_xy-y) 0.5)
            (draw-cube (* 0.05 1.0)))
          (glPopMatrix)))
      (set! a 0.0)
      void)))


(definec main-gl-loop
  (let ((size 1.0)
        (angle:double 0.0)
        (i:i64 0)
        (it:i64 0))
    (lambda (time:double)
      (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
      (set-view)
      (glLoadIdentity)

      (glTranslated 0.0 0.0 -5.0)
      ;;(glRotated (* time 0.002) 0.7 0.7 0.0)
      (glRotated 90.0 0.0 0.0 1.0)
      (glRotated -20.0 0.0 1.0 0.0)
      (glRotated (* time 0.001 (_fader15)) 1.0 0.0 0.0)
      (draw-cube-volume 1.0)
      (glTranslated -0.4 -0.4 -0.5)
      (glPushMatrix)

      (dotimes (it 16)
        (draw-grid time (* 0.15 (i64tod it)) (* 0.01 (i64tod it))))
      
      (glPopMatrix))))

;; standard impromptu callback                                                
(define opengl-callback
  (lambda (time)
    (main-gl-loop time)
    (gl:swap-buffers glctx)
    (callback (+ (now) 500.0) 'opengl-callback (+ (now) 1000.0))))

(define glctx (gl:make-ctx ":0.0" #f 0.0 0.0 1024.0 (/ 1024 (/ 16 9))))

(initial-setup)

(opengl-callback (now))

(osc-start-server)