#ifndef TRACE_INC
#define TRACE_INC

c
c   Rob Kutschke, Sept 24, 1998.
c
c   List of intersections of tracks with surfaces, either rplanes
c   or zplanes.
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change 
c            trace.h !
c
c   -------------------------------------------------------- 
c


#include "trace_struct.inc"

      integer trace_max
      parameter (trace_max = 50000)

      integer trace_num         !Number of track intersections
      record /trace_s/ trace_par !List of intersections
      integer trace_num_dum     ! dummy for alignment

      common/trace_par_c/ trace_num, trace_num_dum, trace_par(trace_max)

#endif
