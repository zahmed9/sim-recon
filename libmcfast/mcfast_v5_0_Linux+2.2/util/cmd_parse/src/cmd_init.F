      subroutine cmd_init

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize some variables in the string parser
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "cmd_parse.inc"

c     Local variables
      integer i
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      cmd_nlun = 0
      cmd_lun = 0

      do i=1,cmd_maxlun
        cmd_lunlist(i) = 0
      enddo

      return
      end
