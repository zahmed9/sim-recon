      integer function trk_add_scat_trace(hep, w, path, radl, dedx, eta)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Adds multiple scattering and energy loss event to track intersection
c  list.
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
c  radl      DFLOAT variable
c            Radiation length of material
c
c  dedx      DFLOAT variable
c            dE/dx at (minimum ionzing) of material
c
c  eta       DFLOAT vector
c            Direction cosines of surface
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
#include "trace.inc"
#include "trace_types.inc"
#include "hep_trace.inc"

c     Externals

c     Calling arguments
      integer hep
      record /wtrack_struct/ w
      record /path_struct/ path
      DFLOAT radl, dedx, eta(3)

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(trace_num .ge. trace_max) goto 9999

      trace_num = trace_num + 1
      if(hep_trace(hep).ntrace .eq. 0) then
        hep_trace(hep).first_trace = trace_num
      endif
      hep_trace(hep).ntrace = hep_trace(hep).ntrace + 1

      trace_par(trace_num).hep = hep
      trace_par(trace_num).type = jtrace_scat
      trace_par(trace_num).plane = 0
      trace_par(trace_num).hit = 0
      trace_par(trace_num).radl = radl
      trace_par(trace_num).dedx = dedx
      trace_par(trace_num).path = path.arc
      trace_par(trace_num).time = path.time
      trace_par(trace_num).tau = path.tau

      call ucopy(w, trace_par(trace_num).w, WTRACK_WORD)
      trace_par(trace_num).eta(1) = eta(1)
      trace_par(trace_num).eta(2) = eta(2)
      trace_par(trace_num).eta(3) = eta(3)

c     Normal exit
 1000 trk_add_scat_trace = 0
      return

c     Error exit
 9999 trk_add_scat_trace = 1
      write(6, 5002) trace_num
 5002 format('trk_add_scat_trace: # of track intersections reached ',
     *       i4, '. This is the maximum allowed.')
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:16  garren
c add rcs log line
c
