#include "gen_stable_struct.inc"

c  List of generated Ks's.

      integer ks_gen_max
      parameter (ks_gen_max = 50)

      integer ks_gen_num        !# of generated Ks's
      record /gen_stable_s/ ks_gen !List of generated Ks's
      integer idum_ks           ! dummy for alignment
      common/ks_gen_c/ ks_gen_num, idum_ks,  ks_gen(ks_gen_max)
