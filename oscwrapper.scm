
;;; start osc receiver

(bind-val _xy |2,double| 0.0)
(bind-val _fader |5,double| 0.0)
(bind-val _push |16,double| 0.0)

(definec _fader11 (lambda () (aref _fader 0)))
(definec _fader12 (lambda () (aref _fader 1)))
(definec _fader13 (lambda () (aref _fader 2)))
(definec _fader14 (lambda () (aref _fader 3)))
(definec _fader15 (lambda () (aref _fader 4)))

(definec _push1 (lambda () (aref _push 0)))
(definec _push2 (lambda () (aref _push 1)))
(definec _push3 (lambda () (aref _push 2)))
(definec _push4 (lambda () (aref _push 3)))
(definec _push5 (lambda () (aref _push 4)))
(definec _push6 (lambda () (aref _push 5)))
(definec _push7 (lambda () (aref _push 6)))
(definec _push8 (lambda () (aref _push 7)))
(definec _push9 (lambda () (aref _push 8)))
(definec _push10 (lambda () (aref _push 9)))
(definec _push11 (lambda () (aref _push 10)))
(definec _push12 (lambda () (aref _push 11)))
(definec _push13 (lambda () (aref _push 12)))
(definec _push14 (lambda () (aref _push 13)))
(definec _push15 (lambda () (aref _push 14)))
(definec _push16 (lambda () (aref _push 15)))

(definec _xy-x (lambda () (aref _xy 0)))
(definec _xy-y (lambda () (aref _xy 1)))

;; native scheme

(define *push* ())

(definec setfader
  (lambda (id:i64 f:double)
	(aset! _fader id f)))

(definec setpusher
  (lambda (id:i64 f:double)
	(aset! _push id f)))

(definec setxy
  (lambda (x:double y:double)
	(aset! _xy 0 x)
	(aset! _xy 1 y)))


(define osc-receive-8000
  (lambda (timestamp address . args)
	;;(println 'port 8000 address '-> args)

	;; analyze push buttons
	(dotimes (i 16)
	  (when (string=? (string-append "/2/push" (number->string (+ 1 i))) address)
			(setpusher i (car args))))

	(dotimes (i 5)
	  (when (string=? (string-append "/1/fader" (number->string (+ 1 i))) address)
			(setfader i (car args))))

	(when (string=? address "/3/xy")
		  (setxy (car args) (cadr args)))
	))

(io:osc:start-server 8000 "osc-receive-8000")





;; extempore lang

(definec osc-receive-8000
  (lambda (address:i8* types:i8* args:i8*)
    (let ((data (bitcast args i32*)))
	  (let ((a (ftod (unswap32f (pref data 0))))
			(b (ftod (unswap32f (pref data 1))))
			(i 0))
		(printf "address:%s  type:%s arg1:%f arg2:%f\n"
				address types a b)
		(cond ((= (strcmp address "/1/fader1") 0)
			   (set! _fader11 a))
			  ((= (strcmp address "/1/fader2") 0)
			   (set! _fader12 a))
			  ((= (strcmp address "/1/fader3") 0)
			   (set! _fader13 a))
			  ((= (strcmp address "/1/fader4") 0)
			   (set! _fader14 a))
			  ((= (strcmp address "/1/fader5") 0)
			   (set! _fader15 a))
			  ((= (strcmp address "/1/toggle1") 0)
			   (set! _toggle11 a))
			  ((= (strcmp address "/1/toggle2") 0)
			   (set! _toggle12 a))
			  ((= (strcmp address "/1/toggle3") 0)
			   (set! _toggle13 a))
			  ((= (strcmp address "/1/toggle4") 0)
			   (set! _toggle14 a))
			  ((= (strcmp address "/3/toggle1") 0)
			   (set! _toggle31 a))
			  ((= (strcmp address "/3/toggle2") 0)
			   (set! _toggle32 a))
			  ((= (strcmp address "/3/toggle3") 0)
			   (set! _toggle33 a))
			  ((= (strcmp address "/3/toggle4") 0)
			   (set! _toggle34 a))
			  ((= (strcmp address "/3/xy") 0)
			   (aset! _xy 0 a)
			   (aset! _xy 1 b))))
		)
	  (printf "+")))

(io:osc:start-server 8000 "osc-receive-8000" (llvm:get-native-function "osc-receive-8000"))

