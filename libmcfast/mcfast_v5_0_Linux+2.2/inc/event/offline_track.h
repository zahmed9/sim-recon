#ifndef TRACK_OFFLINE_H
#define TRACK_OFFLINE_H

#include "offline_track_struct.h"

/*
   List of tracks reconstucted offline.

   -------------------------------------------------------
   WARNING: if you change this file, also make sure you change 
            offline_track.inc !
   -------------------------------------------------------- 


*/

#define trk_off_max 500         /* Maximum number of trace points.       */
#define TRK_OFF_MAX trk_off_max 

extern struct trk_off_c {
  int trk_off_num;
  int trk_off_dum;
  Offline_track_s trk_off[trk_off_max];
} trk_off_c_;


#endif

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:38  eugenio
 * Initial revision
 *
 * Revision 1.2  1999/11/17 16:55:19  mcbride
 * updated common block name -- see devel. notes
 *
 * Revision 1.1  1998/09/15  04:21:07  kutschke
 * New file.
 *
 *
 */
