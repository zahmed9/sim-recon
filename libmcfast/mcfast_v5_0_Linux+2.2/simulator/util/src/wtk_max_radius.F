      function wtk_max_radius(w, bf)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculates the maximum radius of curvature of a track in an arbitrarily
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
      DFLOAT wtk_max_radius

c     calling arguments
      record /wtrack_struct/ w
      record /bfield_struct/ bf

c     local variables
      DFLOAT a, rho, cross, disc, rsq, da
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     radius = pt / (c_b * Bfield * Q)

      a = c_b * bf.bmag * w.q

      if(a .eq. 0.) then
        if(w.pt .gt. 0.) then
          wtk_max_radius = 1.e10
        else
          wtk_max_radius = sqrt(w.x**2 + w.y**2)
        endif

      else if(bf.type .eq. 1) then    !x field
        wtk_max_radius = 1.e10

      else if(bf.type .eq. 2) then    !y field
        wtk_max_radius = 1.e10

      else if(bf.type .eq. 4) then    !z field
        if(w.pt .gt. 0.) then
          rho = a / w.pt
          cross = (w.x*w.py - w.y*w.px) / w.pt
          rsq = w.x**2 + w.y**2
          disc = sqrt(1. - 2.*rho*cross + rho**2 * rsq )
          da   = (-2.*cross + rho * rsq) / (disc + 1.)
          wtk_max_radius = abs(da + 2. / rho)
        else
          wtk_max_radius = sqrt(w.x**2 + w.y**2)
        endif

      else                        !Other B field types
        wtk_max_radius = 1.e10

      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:01  garren
c add rcs log line
c
