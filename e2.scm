;;;(load "/Users/mlozanov/Documents/extempore/libs/dsp_library.scm")

(load "/Users/mlozanov/Documents/scheme/openglsetup.scm")
(load "/Users/mlozanov/Documents/scheme/primitives.scm")

(definec load-and-compile-vertex-shader
  (let ((shader-object (glCreateShader GL_VERTEX_SHADER))
		(size (stack-alloc 1 i32)))
  (lambda (source:i8**)
	(glShaderSource shader-object 1 source size))))

(define *vs* "void main(void) {\n
   vec4 a = gl_Vertex;\n
   a.x = a.x * 0.5;\n
   a.y = a.y * 0.5;\n
\n
\n
   gl_Position = gl_ModelViewProjectionMatrix * a;\n
\n
}\n")

(definec vs-c
  (let ((vs "void main(void) {\n
   vec4 a = gl_Vertex;\n
   a.x = a.x * 0.5;\n
   a.y = a.y * 0.5;\n
\n
\n
   gl_Position = gl_ModelViewProjectionMatrix * a;\n
\n
}\n"))
	(lambda ()
	  vs)))

(definec s
  (lambda ()
	(load-and-compile-vertex-shader (pref-ptr (vs-c) 0))))

(definec main-gl-loop
  (let ((size 1.0)
		(angle:double 0.0)
		(i:i64 0))
	(lambda (time:double)
	  (glClear (+ GL_COLOR_BUFFER_BIT GL_DEPTH_BUFFER_BIT))
	  (set-view)
	  (glLoadIdentity)

	  (glTranslated 0.0 0.0 -2.0)
	  (glRotated (+ (* 0.001 time) angle) 0.0 1.0 0.0)
	  (draw-cube-volume 0.4)
	  (glTranslated 0.0 0.0 -0.5)
	  (dotimes (i 25)
		(glPushMatrix)
		(glTranslated (- 0.15 (* (random) 0.3))
					  (- 0.15 (* (random) 0.3))
					  (- 0.15 (* (random) 0.3)))
		(draw-basis (* 0.2 size))
		(glColor3d 0.6 0.6 0.5)
		(draw-cube (* 0.04 size))
		(glPopMatrix)))))


;; standard impromptu callback                                                
(define opengl-callback
  (lambda (time)
	(main-gl-loop time)
	(gl:swap-buffers glctx)
	(callback (+ (now) 500.0) 'opengl-callback (+ (now) 1000.0))))

(define glctx (gl:make-ctx ":0.1" #f 8.0 360.0 720.0 480.0))

(initial-setup)

(definec get-cube-buffer
  (let ((b (heap-alloc 1024 float)))
	(lambda ()
	  b)))

(definec get-cube-buffer-i8
  (let ((b (heap-alloc (* 4 1024) i8)))
	(lambda ()
	  b)))

(definec get1
  (lambda ()
	(let ((a (pref (get-gl-targets) 0)))
	  (glBindBuffer GL_ARRAY_BUFFER (pref (get-gl-targets) 0))
	  (let ((ptr:i8* (bitcast (get-cube-buffer) i8*)))
		(glBufferData GL_ARRAY_BUFFER 4096 ptr GL_DYNAMIC_DRAW))
	  (glBindBuffer GL_ARRAY_BUFFER 0)
	  (printf "%d\n" a))))

(get1)

(define libglfw (sys:open-dylib "libglfw.dylib"))))


(definec get-mouse-x
  (let ((x (heap-alloc 1 i32)))
	(lambda ()
	  x)))

(definec get-mouse-y
  (let ((y (heap-alloc 1 i32)))
	(lambda ()
	  y)))

(definec get-mouse
  (lambda ()
	(let ((x (get-mouse-x))
		  (y (get-mouse-y)))
	  (glfwGetMousePos x y)
	  (printf "%d \n" (pref x 0))
	  (printf "%d\n" (pref y 0))
	  x)))

(definec test-1
  (let ((a (alloc |1024,float|)))
	(lambda ()
	  (bitcast a i8*))))

(test-1.a)

(get-mouse)

(opengl-callback (now))
