      function wtk_radius_curvature(w, bf)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculates the radius of curvature of a track in an arbitrarily
c  oriented, fixed B field.
c
c  w        w track structure (read)
c           Initial track parameters
c
c  bf       B field structure (read)
c           B field information
c
c Returns:  Radius of curvature
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

c     Externals
      DFLOAT wtk_radius_curvature

c     calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     local variables
      DFLOAT a, disc, dot
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     radius = pt / (c_b * Bfield * Q)

      a = c_b * bf.bmag * w.q

      if(a .eq. 0.) then
        wtk_radius_curvature = 1.e10

      else
        dot = w.px*bf.bdir(1) + w.py*bf.bdir(2) + w.pz*bf.bdir(3)
        disc = w.px**2 + w.py**2 + w.pz**2 - dot**2
        if(disc .le. 0.) then
          wtk_radius_curvature = 0.
        else
          wtk_radius_curvature = sqrt(disc) / abs(a)
        endif
        
      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:04  garren
c add rcs log line
c
