#ifndef TRACK_FORWARD_STRUCT
#define TRACK_FORWARD_STRUCT

/*

   Rob Kutschke, Oct. 23, 1998.

   Tracks used fitted useing the ftrack fitter (dipole fields, etc)
   All variables have the prefix "trf_"

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            track_forward.inc !

   --------------------------------------------------------

*/

#include "track_forward_struct.h"

#define MAX_TRF 500


extern struct Trf_par_c {
  int             trf_num;              /* Number of tracks. */
  int             idm_trf;              /* Alignment dummy.  */
  track_forward_s trf_par[MAX_TRF];     /* Track parameters. */
} trf_par_c_;

#endif
