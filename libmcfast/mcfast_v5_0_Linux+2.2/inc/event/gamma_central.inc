#include "gamma_central_struct.inc"

c    Gammas reconstructed in the central region.

c    All variables have the prefix "gmc_"

      integer max_gmc
      parameter (max_gmc = 400)

      integer gmc_num           !Number of gammas
      record /gamma_central_s/ gmc_par	!Track parameters
      integer idum_gmc          ! dummmy for alignment
      common /gamma_central_c/ gmc_num, idum_gmc, gmc_par(max_gmc)
