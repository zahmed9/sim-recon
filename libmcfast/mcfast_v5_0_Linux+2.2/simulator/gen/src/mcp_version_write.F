      subroutine mcp_version_write(lun)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Write version number to Fortran device lun.
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_version.inc"
#include "mcp_time.inc"

c     Calling argument
      integer lun

c     Local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(lun,5020) mcp_version, mcp_cinit.date, mcp_cinit.time
 5020 format(//40('*')/
     * 'Fast Monte Carlo (mcfast) version ',a/,
     * 2a//,
     * 'To get help on running mcfast, type',//
     * '       mcfast -h'//
     * 40('*')// )

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:07:59  garren
c add hooks to initialize user trigger code
c
