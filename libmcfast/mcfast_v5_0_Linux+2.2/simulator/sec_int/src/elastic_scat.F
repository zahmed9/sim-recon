	integer function elastic_scat(w1,hep,w2)
	implicit none
	
#include "const.inc"
#include "stdhep.inc"
#include "wtrack_struct.inc"

	record /wtrack_struct/ w1, w2
	integer hep, id
	DFLOAT pscale,xmass,phi,pt
	
	real rann, get_gauss
	save pscale
	data pscale /0.1/
c--------------------------------------------	
	call ucopy(w1,w2,WTRACK_WORD)
	xmass = sqrt(w1.E**2-w1.p**2)
	
	pt = sqrt(-log(rann(0)))*pscale 
	 
	if(pt.gt.w1.p) then
	   w2.px = 0.
	   w2.py = 0.
	   w2.pz = 0.
	   w2.pt = 0.
	   w2.p = 0.
	   w2.E = xmass
	   goto 1000
	 endif  
	
	phi = tpi*rann(0)
	
	w2.px = pt*cos(phi)
	w2.py = pt*sin(phi)
	w2.pz = sqrt(w1.p**2-pt**2)
	
	call rotate_wtk(w2,w1,w2)
	
 1000	elastic_scat = 0
        return
	
c     Error exit
 9999	elastic_scat = 1
	return
	end
