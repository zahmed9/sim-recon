      integer function trk_trace_gamma(hep, path, w, type, ipln,
     *                                 convert)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Check whether gamma pair converts in a material plane
c
c  Inputs:
c  hep       integer variable
c            Position of track in HEPEVT list
c
c  path      Path structure
c            Path information for gamma
c
c  w         wtrack structure
c            w track parameters
c
c  type      integer variable
c            Plane type (1=radial, 2=z)
c
c  ipln      integer variable
c            Plane number in list
c
c  Output:
c  convert   integer variable
c            0 ==> gamma did not pair convert
c            1 ==> gamma pair converted
c
c  Return:
c  0 ==> all OK
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c      save

#include "const.inc"
#include "path_struct.inc"
#include "wtrack_struct.inc"
#include "trace.inc"
#include "trace_types.inc"
#include "rplane.inc"
#include "zplane.inc"
#include "mcp_summary.inc"

c     Externals
      external trk_add_final_trace
      external trk_pair_convert
      external rann

      integer  trk_add_final_trace
      integer  trk_pair_convert
      real     rann

c     Calling arguments
      integer hep
      record /path_struct/ path
      record /wtrack_struct/ w
      integer type, ipln, convert

c     Local variables
      integer status
      DFLOAT dot, rr, comp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     See if gamma converts; conversion length = 9/7 Rad. length
c     Account for path length 1/costh effect
      if(type .eq. 1) then
        dot = abs(w.px*w.x + w.py*w.y) / (w.p*rpln_par(ipln).radius)
        comp = exp(-7./9.*rpln_par(ipln).radl/dot)
      else
        dot = abs(w.pz) / w.p
        comp = exp(-7./9.*zpln_par(ipln).radl/dot)
      endif
      rr = rann(0)
      if(rr .gt. comp) then
        convert = 1
        status = trk_pair_convert(hep, w, path)
c        status = trk_add_final_trace(hep, w, ipln, path, type,
c     &                                jtrace_pair)
        if(status .ne. 0) goto 9998
      else
        convert = 0
      endif

 1000 trk_trace_gamma = 0

      return

c     Too many track intersections
 9998 write(6, 5002) trace_num, mcp_all.event
 5002 format('trk_trace_gamma: # of track intersections reached ',i4,
     *       'in event ',i7,'.'/
     *       'This is the maximum allowed.')
      trk_trace_gamma = 1
      convert = 0

      return

      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.5  1997/04/23 21:38:38  bphyslib
c added call to trk_pair_convert again
c
c

