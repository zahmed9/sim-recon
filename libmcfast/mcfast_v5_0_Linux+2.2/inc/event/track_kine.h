#ifndef TRACK_KINE_H
#define TRACK_KINE_H 

#include "track_kine_struct.h"

/* Tracks used in analysis, kinematic and vertex fitting
 * Tracks include final state particles, B, D, etc.
 * All variables have the prefix "trk_".
*/

#define max_trk 1000
  
extern struct _trk_kine_c{
    int trk_num;    /* Number of tracks */
    int idm_tkk;    /* Alignment dummy  */
    Track_kine_s trk_kine[max_trk];
} trk_kine_c_;
  
#endif
