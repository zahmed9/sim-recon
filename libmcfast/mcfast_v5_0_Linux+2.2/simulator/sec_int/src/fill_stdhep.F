	integer function fill_stdhep(w,hep,id,wtime)
	implicit none
	
#include "const.inc"
#include "stdhep.inc"
#include "wtrack_struct.inc"
#include "vtxhep.inc"

c	Calling Arguments
	integer id, hep
	record /wtrack_struct/ w
	DFLOAT wtime
	
c	Local variables
	DFLOAT conv	
	
c-----------------------------------------
	if (nhep .ge. nmxhep) goto 9999

	nhep = nhep + 1

	isthep(nhep) = 1
	idhep(nhep)  = id
	jmulti(nhep) = jmulti(hep)
	
        jmohep(1,nhep) = hep
        jmohep(2,nhep) = 0
        jdahep(1,nhep) = 0
        jdahep(2,nhep) = 0
	
	phep(1,nhep) = w.px
	phep(2,nhep) = w.py
	phep(3,nhep) = w.pz
	phep(4,nhep) = w.E
	phep(5,nhep) = sqrt(w.E**2-w.p**2)
	
c     Store in mm
        conv = 1000. / unit_meter 
        vhep(1,nhep) = w.x * conv
        vhep(2,nhep) = w.y * conv
        vhep(3,nhep) = w.z * conv
        vhep(4,nhep) = clight * wtime * conv
        ipvhep(nhep) = vtx_hep_n
	
c     Normal exit	
	fill_stdhep = 0
	return
	
c     Error exit
 9999   fill_stdhep = 1
	return
	end
			
