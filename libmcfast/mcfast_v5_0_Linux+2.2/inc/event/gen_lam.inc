#include "gen_stable_struct.inc"

c  List of generated lambdas.

      integer lam_gen_max
      parameter (lam_gen_max = 200)

      integer lam_gen_num       !# of generated lambdas
      record /gen_stable_s/ lam_gen !List of generated lambdas
      integer idum_lam          ! dummy for alignment
      common/lam_gen_c/ lam_gen_num, idum_lam, lam_gen(lam_gen_max)
