#include "offline_gamma_struct.inc"

c    All reconstructed gammas.

      integer gam_off_max
      parameter (gam_off_max = 400)

      integer gam_off_num       !Number of gammas
      record /offline_gamma_s/ gam_off !List of gammas
      integer idm_gaof          ! alignment dummy
      common /gam_off_c/ gam_off_num, idm_gaof,
     +  gam_off(gam_off_max)
