
      subroutine rotate_wtk(w,w1,wsec) 
c***********************************************************************	      

      implicit none
      
#include "const.inc"      
#include "wtrack_struct.inc"

	record /wtrack_struct/w,w1,wsec
	DFLOAT masq,sinthe,costhe,sinphi,cosphi
	DFLOAT rot(3,3), ptsq, ppsq, pr(3),p(3)
	integer j
	
c***********************************************************************
	      
	call ucopy(w,wsec,WTRACK_WORD)

	if(w1.pt.lt.1.0E-20) return
	
	masq = w.E**2 - w.p**2
	sinthe = w1.pt/w1.p
	costhe = w1.pz/w1.p
	
	sinphi = w1.py/w1.pt
	cosphi = w1.px/w1.pt 
	
C...Rotate,  from z axis to direction (theta,phi). 
        rot(1,1)=costhe*cosphi 
        rot(1,2)=-sinphi 
        rot(1,3)=sinthe*cosphi 
        rot(2,1)=costhe*sinphi 
        rot(2,2)=cosphi 
        rot(2,3)=sinthe*sinphi 
        rot(3,1)=-sinthe 
        rot(3,2)=0. 
        rot(3,3)=costhe
        
        pr(1) = w.px
        pr(2) = w.py
        pr(3) = w.pz
  
        do 140 j=1,3 
           p(j)=rot(j,1)*pr(1)+rot(j,2)*pr(2)+rot(j,3)*pr(3) 
  140   continue 
  
	wsec.px = P(1)
	wsec.py = p(2)
	wsec.pz = p(3)
	ptsq = p(1)*p(1) + p(2)*p(2)
	ppsq = ptsq+p(3)*p(3)
	wsec.pt = sqrt(ptsq)
	wsec.p = sqrt(ppsq)
	wsec.e = sqrt(ppsq+masq)

 
 
      return 
      end 
