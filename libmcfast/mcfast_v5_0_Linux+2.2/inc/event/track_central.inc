#include "track_central_struct.inc"

c    Tracks used for fitting in central region (solenoidal field)

c    All variables have the prefix "trc_"

      integer max_trc
      parameter (max_trc = 500)

      integer trc_num           !Number of tracks
      record /track_central_s/ trc_par !Track parameters
      integer idm_tcn           ! alignment dummy
      common /trc_par_c/ trc_num, idm_tcn, trc_par(max_trc)
