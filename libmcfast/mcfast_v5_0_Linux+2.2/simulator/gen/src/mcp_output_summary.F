      subroutine mcp_output_summary

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   MCFIO summary
C   ASB 11/10/94
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_luns.inc"
#include "mcfio.inc"
#include "mcp_mcfio.inc"

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(mcfio_out) then
        write(6,5000)
        write(mcp_llpt,5000)
5000    format('Closing MCfio files')
        call mcfio_Close(ostr_out)
      endif
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:54  garren
c add hooks to initialize user trigger code
c
