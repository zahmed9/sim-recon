      subroutine usr_generate_event

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User routine to control the generation of internal events.
c   Called by mcp_generate_event.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "stdhep.inc"
#include "mcp_luns.inc"

c     Local variables
      logical init

      data init/.TRUE./
      save init
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(init) then
        init = .FALSE.
        write(6,5000)
        write(mcp_llpt,5000)
5000    format('usr_generate_event: default routine')
      endif

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:40  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:03  garren
c add hooks to initialize user trigger code
c
