      integer function move_wtk_arc_b0(w1, s3d, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in zero B field.
c
c  w1       w track structure (read)
c           Initial track parameters
c
c  s3d      DFLOAT variable (read)
c           Arc length in 3-D to project track
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters after move
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   The equations of motion are
c
c     Px = Px0
c     Py = Py0
c     Pz = Pz0
c
c      x = x0 + (Px0/P) * s3d
c      y = y0 + {Py0/P) * s3d
c      z = z0 + (Pz0/P) * s3d
c
c   where s = 3-D arc length
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT soverp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     quit if no p
      if(w1.p .eq. 0.) goto 9999

      soverp = s3d / w1.p

      w2.px = w1.px
      w2.py = w1.py
      w2.pz = w1.pz
      w2.E = w1.E
      w2.x = w1.x + soverp * w1.px
      w2.y = w1.y + soverp * w1.py
      w2.z = w1.z + soverp * w1.pz
      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

c     normal return
      move_wtk_arc_b0 = 0

      return

c     error return
9999  move_wtk_arc_b0 = 1
      call ucopy(w1, w2, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:40  garren
c add rcs log line
c
