      integer function trk_add_dummy_trace(hep, w, path, plane_type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Adds a dummy point to track intersection list.
c
c  Inputs:
c  hep       integer variable
c            Position of particle in HEPEVT list
c
c  w         w track structure
c            Track parameters
c
c  path      path structure
c            Path information
c
c  plane_type  integer variable
c              Type of plane (1=rplane, 2=zplane)
c
c  Returns:
c            0 if no error
c            1 if overflow
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "path_struct.inc"
#include "trace_central.inc"
#include "trace_forward.inc"
#include "trace_types.inc"
#include "hep_trace.inc"

c     Externals

c     Calling arguments
      integer hep, plane_type
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(plane_type .eq. 1) then
        if(trace_cent_num .ge. trace_cent_max) goto 9998

        trace_cent_num = trace_cent_num + 1

        trace_cent_par(trace_cent_num).hep = hep
        trace_cent_par(trace_cent_num).type = jtrace_dummy
        trace_cent_par(trace_cent_num).plane = 0
        trace_cent_par(trace_cent_num).hit = 0
        trace_cent_par(trace_cent_num).radl = 0.
        trace_cent_par(trace_cent_num).dedx = 0.
        trace_cent_par(trace_cent_num).path = path.arc
        trace_cent_par(trace_cent_num).time = path.time
        trace_cent_par(trace_cent_num).tau = path.tau

        call ucopy(w, trace_cent_par(trace_cent_num).w, WTRACK_WORD)
        trace_cent_par(trace_cent_num).eta(1) = 0.
        trace_cent_par(trace_cent_num).eta(2) = 0.
        trace_cent_par(trace_cent_num).eta(3) = 0.

      else

        if(trace_for_num .ge. trace_for_max) goto 9999

        trace_for_num = trace_for_num + 1

        trace_for_par(trace_for_num).hep = hep
        trace_for_par(trace_for_num).type = jtrace_dummy
        trace_for_par(trace_for_num).plane = 0
        trace_for_par(trace_for_num).hit = 0
        trace_for_par(trace_for_num).radl = 0.
        trace_for_par(trace_for_num).dedx = 0.
        trace_for_par(trace_for_num).path = path.arc
        trace_for_par(trace_for_num).time = path.time
        trace_for_par(trace_for_num).tau = path.tau

        call ucopy(w, trace_for_par(trace_for_num).w, WTRACK_WORD)
        trace_for_par(trace_for_num).eta(1) = 0.
        trace_for_par(trace_for_num).eta(2) = 0.
        trace_for_par(trace_for_num).eta(3) = 0.

      endif

c     Normal exit
 1000 trk_add_dummy_trace = 0
      return

c     Error exit
 9998 trk_add_dummy_trace = 1
      write(6, 5001) trace_cent_num
 5001 format('trk_add_dummy_trace: # of central track intersections ',
     *         'reached ',i5, '. This is the maximum allowed.')
      return

c     Error exit
 9999 trk_add_dummy_trace = 1
      write(6, 5002) trace_for_num
 5002 format('trk_add_dummy_trace: # of forward track intersections ',
     *         'reached ',i5, '. This is the maximum allowed.')
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:14  garren
c add rcs log line
c
