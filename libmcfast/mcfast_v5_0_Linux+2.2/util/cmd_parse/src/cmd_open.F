      subroutine cmd_open(cfile, error)

c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Processes the "include" command by opening a new file.
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      implicit none

#include "cmd_parse.inc"

c     external routines
      integer  cmd_lenstr
      external cmd_lenstr

c     Calling argument
      character*(*) cfile
      integer error

c     local variables
      integer leng, lun
c >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(cmd_nlun .ge. cmd_maxlun) goto 9989

      if(cfile .eq. ' ') then
        lun = 5
        write(6,5030)
5030    format(/' Waiting for commands (end with ^D):')
      else
        call cmd_getlun(lun)           !Get new unit number
        if(lun .eq. 0) goto 9988
        open(unit=lun,file=cfile,status='old',err=9985)
      endif

      cmd_nlun = cmd_nlun + 1
      cmd_lunlist(cmd_nlun) = lun
      cmd_lun = lun

c     normal exit
1000  error = 0
      return

c     error opening file
9985  leng = cmd_lenstr(cfile)
      write(6, 5001) cfile(:leng)
5001  format(' cmd_open:  Could not open file: ',a)
      error = 1
      return

c     no more unit numbers available
9988  write(6, 5002)
5002  format(' cmd_open:  Could not get unit number')
      error = 2
      return

c     too many files open at one time
9989  write(6, 5003)
5003  format(' cmd_open:  Too many nested include statements')
      error = 3
      return

      end
