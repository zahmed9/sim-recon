#include "gen_stable_struct.inc"

c  List of generated gammas.

      integer gam_gen_max
      parameter (gam_gen_max = 200)

      integer gam_gen_num       !# of generated gammas
      record /gen_stable_s/ gam_gen !List of generated gammas
      integer idum_gam          ! dummy for alignment
      common/gam_gen_c/ gam_gen_num, idum_gam, gam_gen(gam_gen_max)
