      integer function trk_add_zpln_trace(hep, w, ipln, eta, path, hit)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Adds a track intersection with a zplane
c
c  Inputs:
c  hep       integer variable
c            Position of particle in HEPEVT list
c
c  w         w track structure
c            Track parameters
c
c  ipln      integer variable
c            Plane number in zplane list
c
c  eta(3)    DFLOAT array
c            Direction cosines of the plane at the itersection
c
c  path      path structure
c            Path information
c
c  hit       integer variable
c            Hit number in hit_track list (0 if not active plane)
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
#include "trace_forward.inc"
#include "trace_types.inc"
c#include "hep_trace.inc"
#include "zplane.inc"

c     Externals

c     Calling arguments
      integer hep, ipln, hit
      DFLOAT eta(3)
      record /wtrack_struct/ w
      record /path_struct/ path

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(trace_for_num .ge. trace_for_max) goto 9999

      trace_for_num = trace_for_num + 1
c      if(hep_trace(hep).ntrace .eq. 0) then
c        hep_trace(hep).first_trace = trace_for_num
c      endif
c      hep_trace(hep).ntrace = hep_trace(hep).ntrace + 1

      trace_for_par(trace_for_num).hep = hep
      trace_for_par(trace_for_num).type = jtrace_zplane
      trace_for_par(trace_for_num).plane = ipln
      trace_for_par(trace_for_num).hit = hit
      trace_for_par(trace_for_num).radl = zpln_par(ipln).radl
      trace_for_par(trace_for_num).dedx = zpln_par(ipln).dedx
      trace_for_par(trace_for_num).path = path.arc
      trace_for_par(trace_for_num).time = path.time
      trace_for_par(trace_for_num).tau = path.tau
      call ucopy(w, trace_for_par(trace_for_num).w, WTRACK_WORD)
      trace_for_par(trace_for_num).eta(1) = eta(1)
      trace_for_par(trace_for_num).eta(2) = eta(2)
      trace_for_par(trace_for_num).eta(3) = eta(3)

c     Normal exit
 1000 trk_add_zpln_trace = 0
      return

c     Error exit
 9999 trk_add_zpln_trace = 1
      write(6, 5002) trace_for_num
 5002 format('trk_add_zpln_trace: # of track intersections reached ',
     *       i4, '. This is the maximum allowed.')
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:16  garren
c add rcs log line
c
