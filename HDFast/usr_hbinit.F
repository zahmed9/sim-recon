      subroutine usr_hbinit

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User initialization
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_hbook.inc"

      integer        iquest
      common /quest/ iquest(100)

      integer nwords
      parameter (nwords = 2000000)
      integer hmemor
      common/pawc/hmemor(nwords)

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr
      
c     Local variables
      integer leng, ioerr
      character topdir*30

      data topdir/'mcfast'/
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
5000  format('usr_hbinit: this is the default HBOOK init routine')

      call usr_hsinit

      call hlimit(nwords)

      iquest(10) = 32000      !HBOOK default

      call cmd_getlun(hbk_lun)
      call hropen(hbk_lun, topdir, hbk_file, 'NQ', 1024, ioerr)
      if (ioerr.ne.0) goto 9999

c     Turn top directory into full pathname
      hbk_topdir = '//'//topdir

      call hcdir('//PAWC', ' ')
      return

c     Come here if error opeing Hbook output file
 9999 continue
      leng = cmd_lenstr(hbk_file)
      write (6, 10000, iostat=ioerr) hbk_file(:leng), ioerr
10000 format (' usr_hbinit: Unable to open ',A,' error number = ',I5)
      stop

      end
