      subroutine mcp_qq_init

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Initialize QQ from mcfast
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "mcp_version.inc"
#include "mcp_files.inc"
#include "mcp_luns.inc"
#include "mcp_beams.inc"
#include "mcp_hbook.inc"
#include "mcp_ranseeds.inc"
#include "mcp_summary.inc"
#include "mcp_params.inc"
#include "stdlun.inc"
#include "qqmisc.inc"

c     Externals
      integer lenocc
      external lenocc
c     Local variables
      integer i, error, lmcfast
      logical lfile
      character*80 mcfastdir,qqudef
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     QQ initialization
      call qqlunini       !Unit numbers
      call qbinit         !Init some commons

C     define the default QQ user decay file
      call getenv('MCFAST_DIR',mcfastdir)
      qqudef = mcfastdir
      lmcfast = lenocc(mcfastdir) + 1
      qqudef(lmcfast:) = '/example/simulator/stable.dec'

C     set the QQ user decay file if appropriate
      if(qqufile .ne. ' ')then
        inquire(file=qqufile,exist=lfile)
        if(.not.lfile)then
          print *,'QQ user decay file ',qqufile,' does not exist'
          print *,'The QQ user decay file will be set to ',
     1         '$MCFAST_DIR/example/simulator/stable.dec'
          newdec = qqudef
        else
          newdec = qqufile
        endif
      else
        print *,'Using the default QQ user decay file: ',
     1         '$MCFAST_DIR/example/simulator/stable.dec'
        newdec = qqudef
      endif

      call qqinit(error)  !Read in decay file

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.4  1998/12/17 23:36:19  garren
c directory for default user decay file has changed
c
c Revision 1.3  1997/04/04  18:07:55  garren
c add hooks to initialize user trigger code
c
