      integer function move_wtk_arc(w1, s3d, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in an arbitrarily oriented, fixed
c  B field.
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
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  move_wtk_arc_b0
      integer  move_wtk_arc_bx
      integer  move_wtk_arc_by
      integer  move_wtk_arc_bz
      integer  move_wtk_arc_bxyz
      external move_wtk_arc_b0
      external move_wtk_arc_bx
      external move_wtk_arc_by
      external move_wtk_arc_bz
      external move_wtk_arc_bxyz

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 110, 120, 170, 140, 170, 170, 170), bf.type + 1

 100  status = move_wtk_arc_b0(w1, s3d, bf, w2)
      goto 500

 110  status = move_wtk_arc_bx(w1, s3d, bf, w2)
      goto 500

 120  status = move_wtk_arc_by(w1, s3d, bf, w2)
      goto 500

 140  status = move_wtk_arc_bz(w1, s3d, bf, w2)
      goto 500

 170  status = move_wtk_arc_bxyz(w1, s3d, bf, w2)
      goto 500

 500  move_wtk_arc = status
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:40  garren
c add rcs log line
c
