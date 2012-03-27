;;;(load "/Users/mlozanov/Documents/extempore/libs/dsp_library.scm")

(load "/Users/mlozanov/Documents/scheme/openglsetup.scm")
(load "/Users/mlozanov/Documents/scheme/primitives.scm")

;;; start osc receiver
(bind-val _level1 double 0.0)
(bind-val _level2 double 0.0)

(definec osc-receive-8000
  (lambda (address:i8* types:i8* args:i8*)
    (let ((data (bitcast args i32*)))
      (printf "address:%s  type:%s arg1:%f arg2:%lld\n"
	      address types
	      (ftod (unswap32f (pref data 0)))
	      (unswap32i (pref data 1)))
	  (cond ((= (strcmp address "/1/fader1") 0)
			 (set! _level1 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/fader2") 0)
			 (set! _level2 (ftod (unswap32f (pref data 0))))))
	  (printf "+"))))

(io:osc:start-server 8000 "osc-receive-8000" (llvm:get-native-function "osc-receive-8000"))
;;; osc portion ends

(definec draw-grid
  (let ((width 8.0)
		(height 8.0)
		(i:i64 0)
		(j:i64 0))
	(lambda (time:double randomness:double)
	  (dotimes (i 16)
		(dotimes (j 16)
		  (glPushMatrix)
		  (let ((x (* 0.05 (i64tod i)))
				(y (* 0.05 (i64tod j))))
			(glTranslated (* (+ _level1 (random)) x)
						  (* (+ _level2 (random)) y)
						  0.0)
	  
			(glColor3d _level1 _level2 0.5)
			(draw-cube (* 0.04 1.0)))
		  (glPopMatrix))
		void))))


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
	  (glRotated (* time 0.0002) 0.0 1.0 0.0)
	  (draw-cube-volume 0.4)
	  (glTranslated -0.4 -0.4 -0.5)
	  (glPushMatrix)

	  (dotimes (it 32)
		(glTranslated 0.0 0.0 0.05)
		(draw-grid time (* 0.01 (i64tod i))))
	  
	  (glPopMatrix))))

;; standard impromptu callback                                                
(define opengl-callback
  (lambda (time)
	(main-gl-loop time)
	(gl:swap-buffers glctx)
	(callback (+ (now) 500.0) 'opengl-callback (+ (now) 1000.0))))

(define glctx (gl:make-ctx ":0.1" #f 8.0 360.0 720.0 480.0))

(initial-setup)

(opengl-callback (now))
