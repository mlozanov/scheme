(define libglu (if (string=? "Linux" (sys:platform))
		   (sys:open-dylib "/usr/lib/x86_64-linux-gnu/libGLU.so.1")
		   (if (string=? "Windows" (sys:platform))
		       (sys:open-dylib "Glu32.dll")
		       (sys:open-dylib "/System/Library/Frameworks/OpenGL.framework/OpenGL"))))

(bind-lib libglu gluLookAt [void,double,double,double,double,double,double,double,double,double]*)
(bind-lib libglu gluPerspective [void,double,double,double,double]*)
(bind-lib libglu gluErrorString [i8*,i32]*)

(definec set-view
  (lambda ()
    (glViewport 0 0 1024 576)
    (glMatrixMode 5889)
    (glLoadIdentity)
    (gluPerspective 27.0 (/ 16.0 9.0) 0.01 1000.0)
    (glMatrixMode 5888)
    (glEnable 2929)
	1))

(definec get-gl-targets
  (let ((buffers (heap-alloc 2 i32)))
	(lambda ()
	  buffers)))

(definec gen-gl-targets
  (lambda ()
	(let ((bs (get-gl-targets)))
	  (glGenBuffers 2 bs))))

(definec initial-setup
  (lambda ()
	(gen-gl-targets)))

