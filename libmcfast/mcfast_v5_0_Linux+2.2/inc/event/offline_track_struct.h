#ifndef OFFLINE_TRACK_STRUCT_H
#define OFFLINE_TRACK_STRUCT_H

/*

   Reconstructed charged tracks. Since there are two representations
   (central and forward tracks) we adopt a standard parametrization of
   a 4-momentum and a 3-position.

 -------------------------------------------------------------
 WARNING: if you change this file, also make sure you change 
          offline_track_struct.inc !!!!
 -------------------------------------------------------------

*/

#include "wtrack_struct.h"

#define OFFLINE_TRACK_WORD WTRACK_WORD+51*FLOAT_WORD+5*INT_WORD

typedef struct offline_track_struct{
  wtrack_s       w;          /*    Track parameters                   */
  DFLOAT         mass;       /* Mass                                  */
  DFLOAT         cov[7][7];  /* Covariance matrix                     */
  DFLOAT         chisq;      /* Chisquare of fit - see note 1         */
  int            nhit;       /* Number of hits in fit - see note 1    */
  int            nhit_sil;   /* Number of silicon hits - see note 1   */
  int            nhit_stereo;/* Number of hits with stereo info       */
  int            icov;       /* 0 ==> covariance matrix not defined
                                1 ==> covariance matrix defined
                                2 ==> defined, but no momentum information */
  int            hep;        /* Pos. of corresp. track in HEPEVT list */
  int            dummy;      /* pad to align structure */
} Offline_track_s;

typedef struct offline_track_struct *Offline_track_p;

/*

 Notes:
 1) In the original mcfast, nhit counted the number of hits in the
    fit, even if some hits added more than 1 term to the chisq.
    If the Kalman filter is selected, either by default or with the
    command line "use_kalman T" , then nhit and nhit_sil
    are incremented by 2 for every pixel hit added to the track.
    All other types of hits increment these counters by 1.
    That is, nhit is the number of terms in the chisq and the
    distribution of prob(chisq,nhit-5) should be flat.
    If the Kalman filter is not selected, then nhit and nhit_sil
    are incremented by 1 for all types of hits; also, in this case
    chisq = 0 by definition.  If the Kalman filter is selected,
    then fit_lkalman in fit_params.inc will be .TRUE. .

*/

#endif /* ifndef OFFLINE_TRACK_STRUCT */

/*
 * $Id$
 *
 * $Log$
 * Revision 1.1  2000/06/19 19:58:38  eugenio
 * Initial revision
 *
 * Revision 1.5  1999/11/17 16:54:06  mcbride
 * added pad to align structure
 *
 * Revision 1.4  1999/03/16  23:41:06  kutschke
 * Update some comments.
 *
 * Revision 1.3  1998/09/15  04:26:54  kutschke
 * Bug fix OFFLINE_TRACK_WORD. Use wtrack_struct.h now.
 *
 *
 */
