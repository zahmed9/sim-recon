      integer function move_wtk_xyplane_bx(w1, xpl, eta, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  at the plane defined by xpl(3) and eta(3) an x-oriented B field.
c  At present, this routine can only handle pure x or pure y planes.
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
c           2 ==> plane is not purely x or purely y
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      integer  move_wtk_xplane_bx
      integer  move_wtk_yplane_bx
      external move_wtk_xplane_bx
      external move_wtk_yplane_bx

c     calling arguments
      DFLOAT xpl(3), eta(3)
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (eta(1).ne.0.0.and.eta(2).eq.0.0.and.eta(3).eq.0.0) then
        status = move_wtk_xplane_bx(w1,xpl(1),bf,w2,s3d)
      else if (eta(1).eq.0.0.and.eta(2).ne.0.0.and.eta(3).eq.0.0) then
        status = move_wtk_yplane_bx(w1,xpl(2),bf,w2,s3d)
      else
        status = 2
      end if

      move_wtk_xyplane_bx = status

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:52  garren
c add rcs log line
c
