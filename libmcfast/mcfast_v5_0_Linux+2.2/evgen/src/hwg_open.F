      subroutine hwg_open(istream)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Open files for I/O. 
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig61.inc"
#include "stdlun.inc"
#include "file_names.inc"

c     Externals
      integer  cmd_lenstr
      external cmd_lenstr

c     Local variables
      integer leng,istream,lok

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C---  Open the output file for histos, etc.
      open(unit=lnhout, file=file_lpt, status='new', err=9992)
      
C---  Open the event output file 
      call stdxwinit(file_evt_wrt,'EVGEN with Herwig and QQ',
     1               maxev,istream,lok)
      if(lok.ne.0) go to 9993

c     Normal exit
      return

c     Error opening Herwig output lpt file
9992  leng = max(cmd_lenstr(file_lpt), 1)
      write(6,5102) file_lpt(:leng)
5102  format(' Error opening Herwig lpt file: ', a)
      stop

c     Error opening Herwig output event file
9993  leng = max(cmd_lenstr(file_evt_wrt), 1)
      write(6,5103) file_evt_wrt(:leng)
5103  format(' Error opening Herwig evt file: ', a)
      stop

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.5  2000/01/26 02:51:44  bphyslib
c use herwig61.inc
c
c Revision 1.4  1998/07/09  21:00:22  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.3  1998/06/25  15:48:59  bphyslib
c add all necessary changes from v3_3
c
