      integer function ksub_p1_rotate(pw,vp,mvp)
C     Rotates particle and covariance matrix into original system 
C     In the vertex fitting routines the "Z" direction is
C     always considered to be in the direction of the field
C     regardless of the physical Z direction.
C     Input: track to rotate
C     results are stored in track_dx.inc
C***************************************************************
C     Created 9/06/95   A. Boehnlein  -- version on the cheap
C                       for use with central dipole with field in the X or
C                       Y direction.  Should generalize to use direction
C                       cosines of magnetic field. 
 
C                       Rotates particle and covariance matrix into original 
C                       system 

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "kine_bfld.inc"
#include "bfield_rotation.inc"

c     Calling arguments
      integer mvp
      DFLOAT vp(mvp,mvp)
      record /wtrack_struct/ pw

c     Local variables      
      record /wtrack_struct/ temp
      double precision work(99)
      
c     Quit if no B field or aligned along Z axis      
      if(kine_bfld.type.eq.0.or.kine_bfld.type.eq.4) then
          goto 100
          
      else if(kine_bfld.type.eq.1.or.kine_bfld.type.eq.2) then
          call dmmpy(7,7,
     &              bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),
     &              pw.px,
     &              pw.py,
     &              temp.px,temp.py)
          temp.pt = sqrt(temp.px**2 + temp.py**2)
          temp.p  = sqrt(temp.pt**2 + temp.pz**2)
          temp.q  = pw.q
          call ucopy(temp, pw, WTRACK_WORD)

          call dmmlt(7,7,7,
     &           vp(1,1),vp(1,2),
     &           vp(2,1),
     &           bf_rot(1,1),bf_rot(1,2),bf_rot(2,1),
     &           vp(1,1),vp(1,2),
     &           vp(2,1),
     &           work)
           call dmmlt(7,7,7,
     &           bf_rotinv(1,1),bf_rotinv(1,2),bf_rotinv(2,1),
     &           vp(1,1),vp(1,2),
     &           vp(2,1),
     &           vp(1,1),vp(1,2),
     &           vp(2,1),
     &           work)

      endif
      
c     Normal return
100   ksub_p1_rotate = 0
      return

c     Error return      
c9999  ksub_p1_rotate = -1
c      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.6  1998/05/14 00:10:37  kutschke
c Copy particle charge.
c
c Revision 1.5  1997/04/04  20:32:08  garren
c add rcs log line
c
