      integer function move_wtk_cone(w1, cone, direct, bf, w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a cone
c    (described by the cone structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in an arbitrarily oriented, fixed B
c    field.
c
c  -----------------------------------------------------------------------
c    Note: for now the cone surface is allowed to be on both sides of
c    the apex.
c  -----------------------------------------------------------------------
c
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  cone     cone structure (read)
c           Cone description
c
c  direct   integer variable (read)
c           +1 ==> project track forward to intersection with r
c            0 ==> project track to nearest intersection with r
c           -1 ==> project track backward to intersection with r
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
#include "cone_struct.inc"

c     Externals
      integer  move_wtk_cone_b0
      integer  move_wtk_cone_bxyz

      external move_wtk_cone_b0
      external move_wtk_cone_bxyz

c     Calling arguments
      integer direct
      record /wtrack_struct/ w1, w2
      record /cone_struct/ cone
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 110, 110, 110, 110, 110, 110, 110), bf.type + 1

 100  status = move_wtk_cone_b0(w1, cone, direct, bf, w2, s3d)
      goto 500
      
 110  status = move_wtk_cone_bxyz(w1, cone, direct, bf, w2, s3d)

 500  move_wtk_cone = status
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:43  garren
c add rcs log line
c
