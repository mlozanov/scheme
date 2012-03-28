
;;; start osc receiver
(bind-val _fader1 double 0.0)
(bind-val _fader2 double 0.0)
(bind-val _fader3 double 0.0)
(bind-val _fader4 double 0.0)
(bind-val _fader5 double 0.0)

(bind-val _toggle1 double 0.0)
(bind-val _toggle2 double 0.0)
(bind-val _toggle3 double 0.0)
(bind-val _toggle4 double 0.0)

(definec osc-receive-8000
  (lambda (address:i8* types:i8* args:i8*)
    (let ((data (bitcast args i32*)))
      (printf "address:%s  type:%s arg1:%f arg2:%lld\n"
	      address types
	      (ftod (unswap32f (pref data 0)))
	      (unswap32i (pref data 1)))
	  (cond ((= (strcmp address "/1/fader1") 0)
			 (set! _fader1 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/fader2") 0)
			 (set! _fader2 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/fader3") 0)
			 (set! _fader3 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/fader4") 0)
			 (set! _fader4 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/fader5") 0)
			 (set! _fader5 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/toggle1") 0)
			 (set! _fader4 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/toggle2") 0)
			 (set! _fader4 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/toggle3") 0)
			 (set! _fader4 (ftod (unswap32f (pref data 0)))))
			((= (strcmp address "/1/toggle4") 0)
			 (set! _fader4 (ftod (unswap32f (pref data 0)))))
			)
	  (printf "+"))))

(io:osc:start-server 8000 "osc-receive-8000" (llvm:get-native-function "osc-receive-8000"))
;;; osc portion ends
