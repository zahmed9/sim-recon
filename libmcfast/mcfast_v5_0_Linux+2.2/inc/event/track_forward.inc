#ifndef TRACK_FORWARD_INC
#define TRACK_FORWARD_INC

#include "track_forward_struct.inc"

c
c   Rob Kutschke, Oct. 23, 1998.
c
c   Tracks used fitted useing the ftrack fitter (dipole fields, etc)
c   All variables have the prefix "trf_"
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            track_forward.h !
c
c   --------------------------------------------------------
c

      integer max_trf
      parameter (max_trf = 500)

      integer trf_num           !Number of tracks
      record /track_forward_s/ trf_par !Track parameters
      integer idm_trf           ! alignment dummy
      common /trf_par_c/ trf_num, idm_trf, trf_par(max_trf)

#endif
