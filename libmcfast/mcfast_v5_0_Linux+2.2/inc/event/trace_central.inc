******************************************************************************
*  List of central track intersections with boundaries
******************************************************************************

#include "trace_struct.inc"

      integer trace_cent_max
      parameter (trace_cent_max = 15000)

      integer trace_cent_num
      record /trace_s/ trace_cent_par
      integer idm_tcc           ! alignment dummy
      common/trace_cent_par_c/ trace_cent_num, idm_tcc,
     +  trace_cent_par(trace_cent_max)
