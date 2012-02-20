
(define loop
  (lambda (beat offset dur)
	(play-note (*metro* beat) synth (+ offset (random '(55 63 65 70 72))) 95 3000)
	(callback (*metro* (+ beat (* 1.0 dur))) 'loop (+ beat dur) offset dur)))

(loop (*metro* 'get-beat 4) 0 1/4)
(loop (*metro* 'get-beat 4) 0 1/2)

