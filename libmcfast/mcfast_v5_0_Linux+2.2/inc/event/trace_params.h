#ifndef TRACE_PARAMS_H
#define TRACE_PARAMS_H

/*

   Rob Kutschke, Oct. 20, 1998.

   Parameters used to control the way tracks are traced through the detector.

   -------------------------------------------------------

   WARNING: if you change this file, also make sure you change
            trace_params.inc !

   --------------------------------------------------------

*/

#include "const.h"

extern struct trace_params1 {

  DFLOAT  step_max_distance; /* Max distance to take during step.           */
  DFLOAT  step_max_angle;    /* Max angle to take during step.              */
  DFLOAT  step_max_dedx;     /* Max energy fraction lose during step.       */
  DFLOAT  step_max_mscat;    /* Max mult. scat. angle to allow during step. */
  DFLOAT  trk_max_turns;     /* Max # of turns to trace a track.            */
  DFLOAT  trk_min_kinetic;   /* Stop tracing when kinetic energy falls 
                                below this.                                 */
  DFLOAT  trk_min_brem;      /* Minimim energy photon to emit for bremm.    */
  Logical trk_ldecays;       /* TRUE ==> do decays in flight.               */
  Logical trk_lpair;         /* TRUE ==> do pair conversions.               */
  Logical trk_lhits;         /* TRUE ==> make hits in tracking detector.    */
  Logical trk_lscat;         /* TRUE ==> use multiple scattering.           */
  Logical trk_ldedx;         /* TRUE ==> use energy loss.                   */
  Logical trk_lint;          /* TRUE ==> do secondary interactions.         */
  Logical trk_lintegrated;   /* TRUE ==> use integrated (C++) tracing.      */


} trace_params1_;

#endif
