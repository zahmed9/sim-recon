      subroutine wtk_mscat_brem_elec(w1, radl, eta, Kmin, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add multiple scattering and brem loss to a w track, assuming electron
c  identity. The algorithms are described in the routines wtk_mscat and
c  brem_loss.
c  ..........................................................................
c
c  Inputs:
c  w1         w track structure
c             Track parameters before scatter
c
c  radl       DFLOAT variable
c             Thickness of material in radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Kmin       DFLOAT variable (read)
c             Minimum energy of photon to radiate
c
c  Outputs:
c  w2         w track structure
c             Track parameters after scatter and bremmstrahlung
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Externals
      external get_gauss
      real     get_gauss

c     Calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT radl, eta(3), Kmin

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Do scatter, then bremm.
      call wtk_mscat(w1, radl, eta, w2)
      call wtk_brem_loss_elec(w2, radl, eta, Kmin, w2)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:32:02  garren
c add rcs log line
c
