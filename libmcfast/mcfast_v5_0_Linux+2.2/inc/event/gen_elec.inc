#include "gen_stable_struct.inc"

c  List of generated electrons

      integer elec_gen_max
      parameter (elec_gen_max = 200)

      integer elec_gen_num      !# of generated electrons
      record /gen_stable_s/ elec_gen !List of generated electrons
      integer idum_elec         ! dummy for alignment
      common /elec_gen_c/ elec_gen_num, idum_elec,
     +  elec_gen(elec_gen_max)
