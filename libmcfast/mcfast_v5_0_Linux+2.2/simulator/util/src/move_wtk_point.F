      integer function move_wtk_point(w1, x, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  nearest (nearest in the x-y plane) the point x(1-3) in an arbitrarily
c  oriented, fixed B field.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  x(3)     DFLOAT array (read)
c           Point to project track to
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters at z = zs
c
c *s3d      DFLOAT variable (write)
c           3-D arc length the track moved between points
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected to this radius
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  move_wtk_point_b0
c      integer  move_wtk_point_bx
c      integer  move_wtk_point_by
      integer  move_wtk_point_bz
      external move_wtk_point_b0
c      external move_wtk_point_bx
c      external move_wtk_point_by
      external move_wtk_point_bz

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT x(3)
      DFLOAT s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 9999, 9999, 9999, 140, 9999, 9999, 9999), bf.type + 1

 100  status = move_wtk_point_b0(w1, x, bf, w2, s3d)
      goto 500

c 110  status = move_wtk_point_bx(w1, x, bf, w2, s3d)

c 120  status = move_wtk_point_by(w1, x, bf, w2, s3d)

c 130  status = move_wtk_point_bxy(w1, x, bf, w2, s3d)

 140  status = move_wtk_point_bz(w1, x, bf, w2, s3d)
      goto 500

c 150  status = move_wtk_point_bzx(w1, x, bf, w2, s3d)

c 160  status = move_wtk_point_byz(w1, x, bf, w2, s3d)

c 170  status = move_wtk_point_bxyz(w1, x, bf, w2, s3d)

 500  move_wtk_point = status
      return

c     Error return
9999  write(6,5000) bf.type
5000  format('wtk_move_point: Does not support bfield type ',i1)
      move_wtk_point = -1
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:48  garren
c add rcs log line
c
