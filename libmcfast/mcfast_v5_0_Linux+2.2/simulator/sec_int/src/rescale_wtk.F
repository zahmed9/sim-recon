	subroutine rescale_wtk(Escale,w1,w2)
	implicit none
	
#include "wtrack_struct.inc"

	record/wtrack_struct/ w1, w2
	DFLOAT xmassq,pscale, Escale, ptsq, psq, pt

	call ucopy(w1,w2,WTRACK_WORD)
	xmassq = (w1.E**2-w1.p**2)
	
	if(Escale.lt.1.0)then
	 w2.p = w1.p*Escale
	 w2.px = w1.px*Escale
	 w2.py = w1.py*Escale
	 w2.pz = w1.pz*Escale
	 w2.pt = w1.pt*Escale
	 w2.E = sqrt(w2.p**2+xmassq)
	else
	
	 ptsq = w2.px**2 + w2.py**2
	 pt = sqrt(ptsq)
	 w2.p = w1.p*Escale
	 psq = w2.p**2
	 w2.pz = sqrt(psq-ptsq)
	 w2.E = sqrt(psq + xmassq)
	endif
		
	return
	end
