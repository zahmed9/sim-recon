#include "gen_stable_struct.inc"

c  List of muons.

      integer muon_gen_max
      parameter (muon_gen_max = 200)

      integer muon_gen_num      !# of generated muons
      record /gen_stable_s/ muon_gen !List of generated muons
      integer idum_muon         ! dummy for alignment
      common/muon_gen_c/ muon_gen_num, idum_muon, muon_gen(muon_gen_max)
