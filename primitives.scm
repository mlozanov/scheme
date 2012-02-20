
(definec draw-cube
  (lambda (size)
	(let ((s size)
		  (s2 (* size -0.5)))

	  (glTranslated s2 s2 s2)
	  
	  (glBegin GL_QUADS)

	  (glVertex3d 0.0 0.0 0.0)
	  (glVertex3d s 0.0 0.0)
	  (glVertex3d s s 0.0)
	  (glVertex3d 0.0 s 0.0)
	  
	  (glVertex3d 0.0 0.0 s)
	  (glVertex3d s 0.0 s)
	  (glVertex3d s s s)
	  (glVertex3d 0.0 s s)
	  
	  (glVertex3d 0.0 0.0 0.0)
	  (glVertex3d 0.0 s 0.0)
	  (glVertex3d 0.0 s s)
	  (glVertex3d 0.0 0.0 s)

	  (glVertex3d s 0.0 0.0)
	  (glVertex3d s s 0.0)
	  (glVertex3d s s s)
	  (glVertex3d s 0.0 s)

	  (glVertex3d 0.0 0.0 0.0)
	  (glVertex3d 0.0 0.0 s)
	  (glVertex3d s 0.0 s)
	  (glVertex3d s 0.0 0.0)

	  (glVertex3d 0.0 s 0.0)
	  (glVertex3d 0.0 s s)
	  (glVertex3d s s s)
	  (glVertex3d s s 0.0)

	  (glEnd))))

(definec draw-basis
  (lambda (size)
	(glBegin GL_LINES)

	(glColor3d 1.0 0.0 0.0)
	(glVertex3d 0.0 0.0 0.0)
	(glVertex3d size 0.0 0.0)
	
	(glColor3d 0.0 1.0 0.0)
	(glVertex3d 0.0 0.0 0.0)
	(glVertex3d 0.0 size 0.0)
	
	(glColor3d 0.0 0.0 1.0)
	(glVertex3d 0.0 0.0 0.0)
	(glVertex3d 0.0 0.0 size)
	
	(glEnd)))

(definec draw-cube-volume
  (lambda (size)
	(let ((sl (* -1.0 size))
		  (sr size)
		  (st size)
		  (sb (* -1.0 size)))
	  (glPushMatrix)
	  (glTranslated sl st 0.0)
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sr st 0.0)
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sl sb 0.0)
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sr sb 0.0)
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sl st (* -2.0 size))
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sr st (* -2.0 size))
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sl sb (* -2.0 size))
	  (draw-basis (* 0.125 size))
	  (glPopMatrix)

	  (glPushMatrix)
	  (glTranslated sr sb (* -2.0 size))
	  (draw-basis (* 0.125 size))
	  (glPopMatrix))))
