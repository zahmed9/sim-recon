      subroutine newbeam(p)
*
*        Purpose: Accept a 4-vector (P,E) for the photon beam, and
*                 smear it according to a gaussian distribution
*                 of width (resolution * energy)
*
*
*     ____________________________________________________________
*
      implicit none
*
      real p(*)
*
      include "det_resol.h"
*
      real sigma,pnew,dummy
*
      real gausran
      external gausran
      integer i
*
*     ******************************************
*
      sigma = Beam_resol * p(4)
*
      pnew = p(4) + sigma * gausran(dummy)
*
      do 100 i = 1,4
         p(i) = p(i) * pnew / p(4)
 100  Continue
*
      return
      end
