;;(load "/Users/mlozanov/Documents/extempore/libs/dsp_library.scm")

(load "/Users/mlozanov/Documents/scheme/openglsetup.scm")
(load "/Users/mlozanov/Documents/scheme/primitives.scm")
(load "/Users/mlozanov/Documents/scheme/oscwrapper.scm")

(bind-func draw-grid
  (let ((width 8.0)
        (height 8.0)
        (i:i64 0)
        (j:i64 0))
    (lambda (time:double z:double randomness:double)
      (let ((a:double 0.0))
        (set! a (+ a (* 45.0 (sin (* 0.0001 time)))))
        (dotimes (i 8)
          (dotimes (j 8)
            (glPushMatrix)
            (let ((x (* 0.1 (i64tod i)))
                  (y (* 0.1 (i64tod j))))
              (translate x y z)
              (rotate a 0.0 0.707 0.707)
              
              (color (_xy-x) (_xy-y) 0.5 (* 0.3 (_fader14)))
              (if (> (random) (_fader13))
                  (draw-cube (* 0.08 1.0))))
            (glPopMatrix))))
      void)))


(bind-func main-gl-loop
  (let ((size 1.0)
        (angle:double 0.0)
        (i:i64 0)
        (it:i64 0))
    (lambda (time:double)
      (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
      (set-view)
      (glLoadIdentity)

      (translate 0.0 0.0 -5.0)
      (rotate 90.0 0.0 0.0 1.0)
      (rotate -20.0 0.0 1.0 0.0)
      (rotate (* time 0.001 0.5) 1.0 0.0 0.0)
      (draw-cube-volume 1.0)
      (translate -0.4 -0.4 -0.5)
      (glPushMatrix)

      (glEnable GL_BLEND)
      (glDisable GL_DEPTH_TEST)
      (glBlendFunc GL_SRC_ALPHA GL_ONE)
      
      (dotimes (it 8)
        (draw-grid time (* 0.1 (i64tod it)) (* 0.01 (i64tod it))))

      (glDisable GL_BLEND)
      (glEnable GL_DEPTH_TEST)
      
      (glPopMatrix))))

;; standard impromptu callback                                                
(define opengl-callback
  (lambda (time)
    (main-gl-loop time)
    (gl:swap-buffers glctx)
    (callback (+ (now) 1000.0) 'opengl-callback (+ (now) 2000.0))))

(define glctx (gl:make-ctx ":0.0" #f 0.0 0.0 1024.0 (/ 1024 (/ 16 9))))

(initial-setup)

(opengl-callback (now))

(osc-start-server)