*
      subroutine newgamma(p)
*
*        takes a photon 4-vector (stored in p)
*        and smears it accoding to the resolution function:
*
*           sigma    Gam_stat
*           ----- =  --------   + Gam_floor
*             E       sqrt(E)
*
*        This routine should also smear the photon direction in 
*        addition to the photon energy. 
*
*     __________________________________________________________
*
      Implicit None
*
      real p(4)
*
*        sigma: Gaussian width for the energy.
*        eold:  Original photon energy.
*        enew:  Smeared  photon energy.
*
      real  sigma
      real  eold
      real  enew
*
      integer i
*
*        gausran: Funcion to produce a gaussian distributed random
*                 number.
*
      real  gausran
      real  dummy
      external gausran
*
      include "det_resol.h"
*
*     __________________________________________________
*
*        Compute the gaussian width for the photon energy.
*
      sigma = p(4) * Gam_floor + sqrt(p(4)) * Gam_stat
*
      eold = p(4)
*
*        Compute the smeared photon energy, but do not allow the
*        energy to become negative.
*
 100  enew = p(4) + sigma * gausran(dummy)
      if ( enew .le. 0.0 ) go to 100
*
*        Smear the photon four-vector.
*
      do 200 i = 1,4
         p(i) = p(i) * (enew / eold)
 200  continue
*
      return
      end
