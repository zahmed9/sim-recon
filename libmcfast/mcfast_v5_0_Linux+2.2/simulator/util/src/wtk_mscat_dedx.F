      subroutine wtk_mscat_dedx(w1, radl, dedxmn, eta, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add multiple scattering and energy loss to a w track. The algorithms
c  are described in the routines wtk_mscat and dedx_loss.
c  ..........................................................................
c
c  Inputs:
c  w1         w track structure
c             Track parameters before scatter
c
c  radl       DFLOAT variable
c             Thickness of material in radiation lengths
c
c  dedxmn     DFLOAT variable
c             dE/dx loss in GeV at minimum ionizing
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Outputs:
c  w2         w track structure
c             Track parameters after scatter
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT radl, dedxmn, eta(3)

c     Local variables

      DFLOAT half
      parameter( half = 0.5 )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Do 1/2 of energy loss first to get midpoint momentum
      call wtk_dedx_loss(w1, half*dedxmn, eta, w2)
      if(w2.p .eq. 0.) goto 9999
      call wtk_mscat(w2, half*radl, eta, w2)

c     Second half
      call wtk_dedx_loss(w2, half*dedxmn, eta, w2)
      if(w2.p .eq. 0.) goto 9999
      call wtk_mscat(w2, half*radl, eta, w2)

      return

c     Error exit...dE/dx causes particle to lose all momentum
 9999 return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.5  1998/08/11 15:32:41  mkl
c clean up unnused code
c
c Revision 1.4  1997/12/02  22:46:37  kutschke
c Fix 0.5 factor in radl. Made 0.5 typesafe everywhere.
c
c Revision 1.3  1997/04/04  20:32:03  garren
c add rcs log line
c
