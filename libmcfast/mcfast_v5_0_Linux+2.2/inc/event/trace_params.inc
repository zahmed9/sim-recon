#ifndef TRACE_PARAMS_H
#define TRACE_PARAMS_H

c
c
c   Rob Kutschke, Oct. 20, 1998.
c
c   Parameters used to control the way tracks are traced through the detector.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            trace_params.h !
c
c   --------------------------------------------------------
c


#include "const.inc"

      DFLOAT step_max_distance       !Max distance to take during step
      DFLOAT step_max_angle          !Max angle to take during step
      DFLOAT step_max_dedx           !Max energy fraction lose during step
      DFLOAT step_max_mscat          !Max mult. scat. angle to allow during step
      DFLOAT trk_max_turns           !Max # of turns to trace a track
      DFLOAT trk_min_kinetic         !Stop tracing when kin. energy falls below this
      DFLOAT trk_min_brem            !Minimim energy photon to emit for bremm

      logical trk_ldecays            !TRUE ==> do decays in flight
      logical trk_lpair              !TRUE ==> do pair conversions
      logical trk_lhits              !TRUE ==> make hits in tracking detector
      logical trk_lscat              !TRUE ==> use multiple scattering
      logical trk_ldedx              !TRUE ==> use energy loss
      logical trk_lint               !TRUE ==> do secondary interactions
      logical trk_lintegrated        !TRUE ==> use integrated (C++) tracing

      common/trace_params1/
     *  step_max_distance,
     *  step_max_angle,
     *  step_max_dedx,
     *  step_max_mscat,
     *  trk_max_turns,
     *  trk_min_kinetic,
     *  trk_min_brem,
     *  trk_ldecays,
     *  trk_lpair,
     *  trk_lhits,
     *  trk_lscat,
     *  trk_ldedx,
     *  trk_lint,
     *  trk_lintegrated

#endif
