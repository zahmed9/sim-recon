      subroutine trk_trace_copy(t1, t2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Copy trace t1 into trace t2
c
c  Inputs:
c  t1        trace variable
c            Input trace
c
c  Outputs:
c  t2        trace variable
c            Output trace
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "trace_struct.inc"

c     Calling variables
      record /trace_s/ t1, t2

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      t2.hep = t1.hep
      t2.type = t1.type
      t2.plane = t1.plane
      t2.hit = t1.hit
      call ucopy(t1.w, t2.w, WTRACK_WORD)
      do i=1,3
        t2.eta(i) = t1.eta(i)
      end do
      t2.path = t1.path
      t2.time = t1.time
      t2.tau = t1.tau
      t2.material = t1.material
      t2.radl = t1.radl
      t2.dedx = t1.dedx

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:34  garren
c add rcs log line
c
