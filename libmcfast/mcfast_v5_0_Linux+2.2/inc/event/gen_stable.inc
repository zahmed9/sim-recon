#include "gen_stable_struct.inc"

c  List of stable particles, including those which decay in flight

      integer stb_gen_max
      parameter (stb_gen_max = 500)

      integer stb_gen_num       !# of stable generated particles
      record /gen_stable_s/ stb_gen !List of generated particles
      integer idum_stb          ! dummy for alignment
      common/stb_gen_c/ stb_gen_num, idum_stb, stb_gen(stb_gen_max)
