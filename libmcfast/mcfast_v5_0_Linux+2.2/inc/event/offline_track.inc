#ifndef OFFLINE_TRACK_INC
#define OFFLINE_TRACK_INC

#include "offline_track_struct.inc"

c    Offline reconstructed charged tracks.

c   -------------------------------------------------------
c   WARNING: if you change this file, also make sure you change 
c            offline_track.h !
c   -------------------------------------------------------- 

      integer trk_off_max
      parameter (trk_off_max = 500)

c                          !Number of tracks
      integer trk_off_num
c                          !Track parameters
      record /offline_track_struct/ trk_off
c                          !Dummy for alignment
      integer trk_off_dum

      common /trk_off_c/ trk_off_num, trk_off_dum, trk_off(trk_off_max)

#endif
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:58:38  eugenio
c Initial revision
c
c Revision 1.5  2000/01/19 19:38:20  garren
c fix some ! comments which can cause problems for Linux user code
c
c Revision 1.4  1999/11/17  16:55:19  mcbride
c updated common block name -- see devel. notes
c
c Revision 1.3  1998/09/15  04:25:41  kutschke
c Update comments for new .h file.
c
c
