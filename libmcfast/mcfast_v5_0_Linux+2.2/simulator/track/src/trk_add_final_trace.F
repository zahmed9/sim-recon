      integer function trk_add_final_trace(hep, w, ipln, path,
     *                                     plane_type, trace_type)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Adds a final trace to track intersection list.
c
c  Inputs:
c  hep          integer variable
c               Position of particle in HEPEVT list
c
c  w            w track structure
c               Track parameters
c
c  ipln         integer variable
c               Plane number
c
c  path         path structure
c               Path information
c
c  plane_type   integer variable
c               Plane type (1=radial, 2=z, 3=merged trace list)
c
c  trace_type   integer variable
c               Trace type (3=decay, 4=gamma conversion, 5=absorption)
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
c#include "hep_trace.inc"
#include "trace.inc"

c     Externals

c     Calling arguments
      integer hep, ipln, plane_type, trace_type
      DFLOAT eta(3)
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variables

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if (trace_type .ne. jtrace_decay .and.
     *    trace_type .ne. jtrace_pair .and.
     *    trace_type .ne. jtrace_absorb .and.
     *    trace_type .ne. jtrace_shower .and.
     *    trace_type .ne. jtrace_calor) goto 9996

      if (plane_type.eq.1) then

        if(trace_cent_num .ge. trace_cent_max) goto 9998

        trace_cent_num = trace_cent_num + 1

        trace_cent_par(trace_cent_num).hep = hep
        trace_cent_par(trace_cent_num).type = trace_type
        trace_cent_par(trace_cent_num).plane = ipln
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

      else if (plane_type.eq.2) then

        if(trace_for_num .ge. trace_for_max) goto 9999

        trace_for_num = trace_for_num + 1

        trace_for_par(trace_for_num).hep = hep
        trace_for_par(trace_for_num).type = trace_type
        trace_for_par(trace_for_num).plane = ipln
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

      else if (plane_type.eq.3) then

        if(trace_num .ge. trace_max) goto 9995

        trace_num = trace_num + 1

        trace_par(trace_num).hep = hep
        trace_par(trace_num).type = trace_type
        trace_par(trace_num).plane = ipln
        trace_par(trace_num).hit = 0
        trace_par(trace_num).radl = 0.
        trace_par(trace_num).dedx = 0.
        trace_par(trace_num).path = path.arc
        trace_par(trace_num).time = path.time
        trace_par(trace_num).tau = path.tau
        call ucopy(w, trace_par(trace_num).w, WTRACK_WORD)
        trace_par(trace_num).eta(1) = 0.
        trace_par(trace_num).eta(2) = 0.
        trace_par(trace_num).eta(3) = 0.

      else

        goto 9997

      end if

c     Normal exit
 1000 trk_add_final_trace = 0
      return

c     Error exit
 9995 trk_add_final_trace = 1
      write(6, 5004) trace_cent_num
 5004 format('trk_add_final_trace: # of track intersections reached ',
     *       i4, '. This is the maximum allowed.')
      return

c      Error exit
 9996 trk_add_final_trace = 1
      write(6, 5000) trace_type
 5000 format('trk_add_final_trace: Bad trace type ',i2,' used. 
     & Must be 3, 4 or 5.')

c     Error exit
 9997 trk_add_final_trace = 1
      write(6, 5001) plane_type
 5001 format('trk_add_final_trace: Bad plane type ',i2,' used. 
     & Must be 1 or 2.')
      return

c     Error exit
 9998 trk_add_final_trace = 1
      write(6, 5002) trace_cent_num
 5002 format('trk_add_final_trace: # of track intersections reached ',
     *       i4, '. This is the maximum allowed.')
      return

c     Error exit
 9999 trk_add_final_trace = 1
      write(6, 5003) trace_for_num
 5003 format('trk_add_final_trace: # of track intersections reached ',
     *       i4, '. This is the maximum allowed.')

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.5  1997/04/04 20:30:14  garren
c add rcs log line
c
