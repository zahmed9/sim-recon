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
      real sigma,pnew,dummy
      real resolution /0.001/ ! sigma_p/p
      real gausran
      external gausran
      integer i
*
*     ******************************************
*
      sigma=resolution*p(4)
*
      pnew=p(4) + sigma * gausran(dummy)
*
      do 100 i = 1,4
         p(i)=p(i) * pnew / p(4)
 100  Continue
*
      return
      end
