      subroutine stdversn
C
C...print STDHEP version number
C
#include "stdver.inc"
#include "stdlun.inc"
      logical lfirst
      data lfirst/.TRUE./
      save lfirst

      if(lfirst)then
        lfirst = .FALSE.
        stdhep_ver  = '4.08'
        stdhep_date = 'February 24, 2000'
        write(lnhout,1001) stdhep_ver,stdhep_date
      endif
1001  format(//
     1 10X,'********************************************************'/
     2 10X,'*       STDHEP version ',a5,' -  ',a20,'   *'/
     3 10X,'********************************************************'//)
      return
      end
