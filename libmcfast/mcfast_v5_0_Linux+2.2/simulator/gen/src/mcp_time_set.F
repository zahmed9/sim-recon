      subroutine mcp_time_set

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Set the current times
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_time.inc"

c     Calling arguments

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      mcp_ccurr.date = ' '
      mcp_ccurr.time = ' '
      call get_ctime(mcp_ccurr.date, mcp_ccurr.time)
      call get_time(mcp_time.curr)
      call get_cputime(mcp_cpu.curr)

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
