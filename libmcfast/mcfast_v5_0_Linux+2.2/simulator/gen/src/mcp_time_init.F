      subroutine mcp_time_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize wall clock timer
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_time.inc"

c     Local variables
      integer i
      real tlimit
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Cern routine to init time routines
      tlimit = 0.
      call timest(tlimit)

c     Set all current elapsed times and cpu times
      call mcp_time_set
      mcp_cinit.date = mcp_ccurr.date
      mcp_cinit.time = mcp_ccurr.time
      mcp_time.t0 = mcp_time.curr
      mcp_cpu.t0 = mcp_cpu.curr

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:58  garren
c add hooks to initialize user trigger code
c
