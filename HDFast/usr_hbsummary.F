      subroutine usr_hbsummary

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   User HBOOK summary 
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_hbook.inc"
#include "mcp_luns.inc"

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Local variables
      integer maxdir, mlen
      parameter (mlen = 40)
      parameter (maxdir = 40)

      integer icycle, leng_file, leng_dir, ndir, i
      character chdir(maxdir)*(mlen)
      logical lopen
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      write(6,5000)
      write(mcp_llpt,5000)
5000  format('usr_hbsummary: this is default HBOOK summary')

c      call hs_complete

      call hcdir('//PAWC', ' ')
      call hrdir(maxdir, chdir, ndir) !Get list of subdirectories

      leng_file = cmd_lenstr(hbk_file)
      write(6,5011) hbk_file(:leng_file)
      write(mcp_llpt,5011) hbk_file(:leng_file)
 5011 format('HBOOK output file: ',a)

      leng_dir = cmd_lenstr(hbk_topdir)
      write(6,5012) hbk_topdir(:leng_dir)
      write(mcp_llpt,5012) hbk_topdir(:leng_dir)
 5012 format('Top directory: ',a)

      do i=1,ndir
        write(6,5002) chdir(i)
        write(mcp_llpt,5002) chdir(i)
 5002   format('Sub directory: ', a)
      enddo

      call hcdir('//PAWC', ' ')
      call hcdir(hbk_topdir, ' ')

c     Create subdirectories in output file
      do i=1,ndir
        call hmdir(chdir(i), ' ')
      enddo

      call hrout(0, icycle, 'T')     !Write all hists in all subdirectories
      call hrout(1, icycle, 'T')     ! Write the ntuple
      call hldir(' ',' ')
      call hrend('mcfast')
      close(unit=hbk_lun)
c      call rzstat(
c      call houtpu(mcp_llpt)
c      call hldir(' ','T')            !Write list of hists to lpt file

c     On many platforms, HBOOK automagically does IO in C, not in fortran.
c     If this done, then the fortran logical unit was never opened.
c      inquire( unit=hbk_lun, opened=lopen)
c      if ( lopen ) then
c         call hrend(hbk_topdir)
c         close(unit=hbk_lun)
c      else
c         call hrendc(hbk_topdir)
c      endif

      return
      end
