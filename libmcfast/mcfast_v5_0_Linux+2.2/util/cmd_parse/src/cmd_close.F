      subroutine cmd_close

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Closes the current open file
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "cmd_parse.inc"

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(cmd_nlun .eq. 0) return
      if(cmd_lun .ne. 5) close(unit=cmd_lun)

      cmd_nlun = cmd_nlun - 1
      if ( cmd_nlun .eq. 0 ) then
         cmd_lun = 0
      else
         cmd_lun = cmd_lunlist(cmd_nlun)
      endif

      return
      end
