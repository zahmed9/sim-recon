      subroutine mcp_summary

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Summarize simulation run
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"

c     Local variables
      integer i
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call mcp_status(mcp_llpt)
      call mcp_status(6)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:57  garren
c add hooks to initialize user trigger code
c
