#include "gen_track_struct.inc"

c  List of generated charged tracks.

      integer trk_gen_max
      parameter (trk_gen_max = 500)

      integer trk_gen_num       !# of generated tracks
      record /gen_track_s/ trk_gen !List of generated tracks
      integer idum_tkgn         ! dummy for alignment
      common/trk_gen_c/ trk_gen_num, idum_tkgn, trk_gen(trk_gen_max)
