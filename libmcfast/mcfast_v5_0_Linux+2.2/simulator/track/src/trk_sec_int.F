      integer function trk_sec_int(w1,hep,coll,absl,eta,wtime,
     *                                  w2,int_type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add secondary interactions to a w track.
c
c  ..........................................................................
c
c  Inputs:
c  w1         w track structure
c             Track parameters before scatter
c
c  coll       DFLOAT variable
c             # of collision lengths
c
c  asbl       DFLOAT variable
c             # of absorption lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  wtime      DFLOAT variable 
c             time of interaction in STDHEP units 
c
c  Outputs:
c  w2         w track structure
c             Track parameters after interaction if elastic scatter
c
c  int_type   INTEGER variable
c             0=no interaction, 2=inelastic interaction, 1=elastic scatter
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "mcp_summary.inc"
#include "wtrack_struct.inc"

c     Externals
      external sec_inelastic, elastic_scat
      external get_gauss, rann
      
      integer sec_inelastic, elastic_scat
      real    get_gauss, rann

c     Calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT coll, absl, wtime, eta(3)
      integer int_type, id, hep, status

c     Local variables
      DFLOAT col_prob, int_len, abs_len
      DFLOAT pmin, dot
      
      data pmin/1.0/
      
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

	int_type = 0
	call ucopy(w1,w2,WTRACK_WORD)
	if (coll .le. 0.0 .or. coll .lt. absl) goto 1000

c     calculate effective collision length
        dot = abs((eta(1)*w1.px+eta(2)*w1.py+eta(3)*w1.pz)/w1.p)
        int_len = coll/dot
        abs_len = absl/dot
	
c  do we have a collision?

	col_prob = - log(rann(0))
			
	if (col_prob .lt. abs_len .and. w1.p.gt.pmin) then
	   int_type = 2
	   status = sec_inelastic(w1,hep,wtime)
	elseif(col_prob .lt. int_len) then
	   int_type = 1
	   status = elastic_scat(w1,hep,w2)
	endif
	
	if (status .ne. 0) goto 9999
	
 1000   trk_sec_int = 0
	return
	
 9999	trk_sec_int = 1
	return
	end
