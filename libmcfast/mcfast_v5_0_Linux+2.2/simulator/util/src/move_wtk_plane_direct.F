      integer function move_wtk_plane_direct(w1, pln, bf, beatdist, 
     *                                       w2, s3d)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    Projects a track expressed in the w parametrization to a plane
c    (described by the pln structure) in the forward/backward/either
c    direction (direct = +1/-1/0) in an arbitrarily oriented, fixed B
c    field.
c
c
c  w1       w track structure (read)
c           Initial track parameters (px, py, pz, E, x0, y0, z0, pt, p, q)
c
c  pln      plane structure (read)
c           Plane description
c
c  no more 'direct' variable -- always forward solution!
c
c  bf       B field structure (read)
c           B field information
c
c  beatdist distance to beat (in order to speed up algorithms)
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
      integer  move_wtk_plane_direct_b0
      integer  move_wtk_plane_direct_bxyz
      external move_wtk_plane_direct_b0
      external move_wtk_plane_direct_bxyz

c     Calling arguments
      record /wtrack_struct/ w1, w2
      record /plane_struct/ pln
      record /bfield_struct/ bf
      DFLOAT beatdist, s3d

c     local variables
      integer status
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w1.q .eq. 0.) goto 100

      goto (100, 110, 110, 110, 110, 110, 110, 110), bf.type + 1

 100  status = move_wtk_plane_direct_b0(w1, pln, bf, beatdist, w2, s3d)
      goto 500

 110  status = move_wtk_plane_direct_bxyz(w1,pln,bf, beatdist, w2, s3d)

 500  move_wtk_plane_direct = status
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.1  1999/04/21 20:40:03  mkl
c first version of new faster move_wtk_plane* routines
c
c
