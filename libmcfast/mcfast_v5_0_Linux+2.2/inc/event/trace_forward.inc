******************************************************************************
*  List of forward track intersections with boundaries
******************************************************************************

#include "trace_struct.inc"

      integer trace_for_max
      parameter (trace_for_max = 15000)

      integer trace_for_num
      record /trace_s/ trace_for_par
      integer idm_tcf           ! alignment dummy
      common/trace_for_par_c/ trace_for_num, idm_tcf,
     +  trace_for_par(trace_for_max)
