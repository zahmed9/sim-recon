#include "gamma_forward_struct.inc"

c    Gammas reconstructed in the forward direction.

c    All variables have the prefix "gmf_"

      integer max_gmf
      parameter (max_gmf = 400)

      integer gmf_num           !Number of gammas
      record /gamma_forward_s/ gmf_par	!Track parameters
      integer idum_gmf          ! dummy for alignment
      common /gamma_forward_c/ gmf_num, idum_gmf, gmf_par(max_gmf)
