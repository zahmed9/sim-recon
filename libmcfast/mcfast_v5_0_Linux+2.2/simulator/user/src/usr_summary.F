      subroutine usr_summary

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User summary
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
      write(mcp_llpt,5000)
5000  format('usr_summary: this is a dummy routine')

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:41  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:05  garren
c add hooks to initialize user trigger code
c
