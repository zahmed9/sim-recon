
      subroutine hwg_user_init

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   User initialization of the program. 
C   Open files for I/O. 
C   Read and set HERWIG initialization variables to non-default values. 
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "herwig61.inc"
#include "stdlun.inc"
#include "file_names.inc"

      character*80 cmd_string
      external     cmd_string

c     Local variables
      integer error
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C---  Initialize STDHEP unit numbers
      lnhwrt = 23
      lnhrd = 0
      lnhdcy = 0
      lnhout = 22
      lhwout = lnhout

      call hwg_command

c---  Book histograms
      call bookhistos

c     Normal exit
      return

c     Error
9999  write(6,5002) file_input
5002  format(' Could not find input file ', a)
      stop
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.5  2000/01/26 02:51:45  bphyslib
c use herwig61.inc
c
c Revision 1.4  1998/07/09  21:00:22  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.3  1998/06/25  15:49:00  bphyslib
c add all necessary changes from v3_3
c
