      integer function kfil_bfield_rotation()

C>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     6/6/95 A. Boehnlein
C     This routine is used for setting up the rotation matrices for 
c     rotating a track and covariance matrix such that the "Z" direction
C     lies along the direction of the b field.  This set of routines is only
C     used for vertexing!
C     This is the cheap version, designed for quick testing.
C     05/06/96  Added rotation for field in X direction.  Still not generalized
C>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "kine_bfld.inc"
#include "bfield_rotation.inc"

c     Local variables
      DFLOAT work(7)
      integer ifail
C>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call vzero(bf_rot,7*7*FLOAT_WORD)

      if(kine_bfld.type.eq.1) then
	bf_rot(1,3) =  -1.
	bf_rot(2,2) =   1.
	bf_rot(3,1) =   1.
	bf_rot(4,4) =   1.
	bf_rot(5,7) =  -1.
	bf_rot(6,6) =   1.
	bf_rot(7,5) =   1.
      else if(kine_bfld.type.eq.2) then
	bf_rot(1,1) =   1.
	bf_rot(2,3) =  -1.
	bf_rot(3,2) =   1.
	bf_rot(4,4) =   1.
	bf_rot(5,5) =   1.
	bf_rot(6,7) =  -1.
	bf_rot(7,6) =   1.
      else
	bf_rot(1,1) =   1.
	bf_rot(2,2) =   1.
	bf_rot(3,3) =   1.
	bf_rot(4,4) =   1.
	bf_rot(5,5) =   1.
	bf_rot(6,6) =   1.
	bf_rot(7,7) =   1.
      endif 

      call ucopy(bf_rot,bf_rotinv,7*7*FLOAT_WORD)

      call dinv(7,bf_rotinv,7,work,ifail)
      if(ifail.ne.0) then 
        kfil_bfield_rotation = 1
      else
        kfil_bfield_rotation = 0
      endif
      
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:32:05  garren
c add rcs log line
c
