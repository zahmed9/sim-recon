      integer function move_wtk_zplane(w1, zs, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the position z = zs in an arbitrary B field.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  zs       DFLOAT variable (read)
c           z position to which the track should be projected
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
#include "plane_struct.inc"

c     Externals
      integer  move_wtk_zplane_b0
      integer  move_wtk_plane_bxyz
      integer  move_wtk_zplane_bz

      external move_wtk_zplane_b0
      external move_wtk_plane_bxyz
      external move_wtk_zplane_bz

c     calling arguments
      DFLOAT zs
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
      record /plane_struct/ pln
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 200, 200, 200, 140, 200, 200, 200), bf.type + 1

 100  status = move_wtk_zplane_b0(w1, zs, bf, w2, s3d)
      goto 500

 140  status = move_wtk_zplane_bz(w1, zs, bf, w2, s3d)
      goto 500

c     B field in arbitrary direction. Assume we want to find intersection
c     closest to track position
 200  pln.xp(1) = 0.
      pln.xp(2) = 0.
      pln.xp(3) = zs
      pln.eta(1) = 0.
      pln.eta(2) = 0.
      pln.eta(3) = 1.
      status = move_wtk_plane_bxyz(w1, pln, 0, bf, w2, s3d)
      goto 500

 500  move_wtk_zplane = status
      return
      
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:31:54  garren
c add rcs log line
c
