#include "offline_track_struct.inc"
C----------------------------------------------------------------------
C-
C-   Created  21-mar-1994   Amber S. Boehnlein
C-
C----------------------------------------------------------------------
        integer ntrig_l1_track_max
        parameter (ntrig_l1_track_max = 500)

        integer ntrig_l1_track         !# of trigger tracks
        record /offline_track_struct/ trig_l1_track

        common /ntrig_l1_track1/
     *   ntrig_l1_track

        common /ntrig_l1_track2/
     *   trig_l1_track(ntrig_l1_track_max)
