#include "gen_stable_struct.inc"

c  List of generated pi0s.

      integer pi0_gen_max
      parameter (pi0_gen_max = 200)

      integer pi0_gen_num       !# of generated pi0s
      record /gen_stable_s/ pi0_gen !List of generated pi0s
      integer idum_pi0          ! dummy for alignment
      common/pi0_gen_c/ pi0_gen_num, idum_pi0, pi0_gen(pi0_gen_max)
