#ifndef HEP_TRACE_INC
#define HEP_TRACE_INC

c
c   Rob Kutschke, Oct. 20, 1998.
c
c   Information about each HEPEVT track during its trace through the detector
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            hep_trace.h !
c
c   --------------------------------------------------------
c
#include "const.inc"
#include "hep_trace_struct.inc"

      integer hep_trace_max
      parameter (hep_trace_max = MCF_NMXHEP)

      record /hep_trace_s/ hep_trace   ! Points from HEPEVT track
c                                      ! to trace list and hit list
      integer n_obj_hep_trace, idm_trc ! for dbin compatibility

      common/hep_trace_c/
     *  n_obj_hep_trace, idm_trc, hep_trace(hep_trace_max)

#endif
