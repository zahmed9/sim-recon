#ifndef TRACK_KINE_INC
#define TRACK_KINE_INC

c     Track parametrization for general use (analysis, vertex fitting,
c     kinematic fitting)

c -------------------------------------------------------------
c WARNING: if you change this file, also make sure you change 
c          track_kine.h !
c -------------------------------------------------------------

#include "track_kine_struct.inc"

c    Tracks used in analysis, kinematic and vertex fitting
c    Tracks include final state particles, B, D, etc.

c    All variables have the prefix "trk_"

      integer max_trk
      parameter (max_trk = 1000)

c     Number of tracks.
      integer trk_num

c     Alignment Dummy.
      integer idm_tkk

c     Track parameters.
      record /track_kine_s/ trk_kine

      common /trk_kine_c/ trk_num, idm_tkk, trk_kine(max_trk)

#endif
