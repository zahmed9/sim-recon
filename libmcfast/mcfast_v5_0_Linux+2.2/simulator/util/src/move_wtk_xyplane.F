      integer function move_wtk_xyplane(w1, xpl, eta, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the plane defined by xpl(3) and eta(3) an arbitrary B field.
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  xpl(3)   DFLOAT array (read)
c           Point on the plane
c
c  eta(3)   DFLOAT array (read)
c           Outward normal to the plane (assume z component is 0)
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
      integer  move_wtk_xyplane_b0
      integer  move_wtk_xyplane_bz
      integer  move_wtk_plane_b0
      integer  move_wtk_plane_bxyz

      external move_wtk_xyplane_b0
      external move_wtk_xyplane_bz
      external move_wtk_plane_b0
      external move_wtk_plane_bxyz

c     calling arguments
      DFLOAT xpl(3), eta(3)
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
      record /plane_struct/ pln
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 200, 200, 200, 140, 200, 200, 200), bf.type + 1

c     B field = 0. If plane is not aligned in XY plane, use general routine.
c     Assume we want to find intersection closest to track position.
 100  if(eta(3) .ne. 0.) then
        pln.xp(1) = xpl(1)
        pln.xp(2) = xpl(2)
        pln.xp(3) = xpl(3)
        pln.eta(1) = eta(1)
        pln.eta(2) = eta(2)
        pln.eta(3) = eta(3)
	status = move_wtk_plane_b0(w1, pln, 0, bf, w2, s3d)
      else
        status = move_wtk_xyplane_b0(w1, xpl, eta, bf, w2, s3d)
      endif
      goto 500

c     B field aligned along z. Make sure plane is in xy plane
 140  if(eta(3) .ne. 0.) goto 200
      status = move_wtk_xyplane_bz(w1, xpl, eta, bf, w2, s3d)
      goto 500

c     B field in arbitrary direction. Assume we want to find intersection
c     closest to track position
 200  pln.xp(1) = xpl(1)
      pln.xp(2) = xpl(2)
      pln.xp(3) = xpl(3)
      pln.eta(1) = eta(1)
      pln.eta(2) = eta(2)
      pln.eta(3) = eta(3)
      status = move_wtk_plane_bxyz(w1, pln, 0, bf, w2, s3d)
      goto 500
      
 500  move_wtk_xyplane = status
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.6  1999/03/26 20:23:01  mcbride
c fix init for case of general plane and no B field
c
c Revision 1.5  1997/04/04  20:31:51  garren
c add rcs log line
c
