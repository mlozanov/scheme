
;;; start osc receiver
(bind-val _fader11 double 0.0)
(bind-val _fader12 double 0.0)
(bind-val _fader13 double 0.0)
(bind-val _fader14 double 0.0)
(bind-val _fader15 double 0.0)

(bind-val _toggle11 double 0.0)
(bind-val _toggle12 double 0.0)
(bind-val _toggle13 double 0.0)
(bind-val _toggle14 double 0.0)

(bind-val _xy |2,double| 0.0)

(bind-val _toggle31 double 0.0)
(bind-val _toggle32 double 0.0)
(bind-val _toggle33 double 0.0)
(bind-val _toggle34 double 0.0)

(bind-val _push |16,double| 0.0)

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
;		(dotimes (i 16)
;		  (if (= (strcmp address (strcat "/2/push" (symbol->string i))) 0)
;			  (aset! _push i a))))

(io:osc:start-server 8000 "osc-receive-8000" (llvm:get-native-function "osc-receive-8000"))


;; native scheme

(define *push* ())

(define osc-receive-8000
  (lambda (timestamp address . args)
	(println 'port 8000 address '-> args)

	;; analyze push buttons
	(dotimes (i 17)
	  (if (string=? (string-append "/2/push" (number->string i)) address)
		  (println i)))

	;; ...

	(println '+)))

(io:osc:start-server 8000 "osc-receive-8000")


