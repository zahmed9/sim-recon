      subroutine pyt_save_seed

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C    save jetset random number seeds
C
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IMPLICIT NONE

#include "stdlun.inc"
#include "pydatr.inc"
*
      integer        islate           ! This common is used to communicate with 
      common /slate/ islate(40)       ! the cernlib routine getenvf

      integer        
     &    ioerr,                      ! Used in open calls
     &    iw
      character*256  env_trans        ! Tranlated environment name

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C
C...   Save the state of the random number so that we can pick up from
C       here
C
      call getenvf ('LUND_RAN_OUT', env_trans)
      if (islate(1).eq.0 ) then
        open (unit=55, file='LUND_RAN', form='unformatted',
     &     status='UNKNOWN', iostat=ioerr )
      else
        open (unit=55, file=env_trans, form='unformatted', 
     &     status='UNKNOWN', iostat=ioerr  )
      endif
      if (ioerr.eq.0) then
        call pyrget (55,0)
        close (55)
        write (LNHOUT, 1002, iostat=ioerr) ( mrpy(iw), iw=1,6 )
        write (LNHOUT, 1003, iostat=ioerr) ( rrpy(iw), iw=1,100 )
      else 
        write (LNHOUT, 1004, iostat=ioerr) 
      endif
      return
 1002 FORMAT(' Last random numbers used by LUND: '/' '/' MRPY: ',6I7/
     &       ' RRPY: ' )
 1003 FORMAT(' ',10F8.5 ) 
 1004 FORMAT(' Unable to open file to save LUND random number state.')
      END
 
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.3  1998/07/09 21:00:23  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.2  1998/06/25  15:49:02  bphyslib
c add all necessary changes from v3_3
c
