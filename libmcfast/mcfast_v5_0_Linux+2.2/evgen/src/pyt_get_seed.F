 
      subroutine pyt_get_seed
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   get jetset random number seeds
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "stdlun.inc"
#include "pydat1.inc"
#include "pydatr.inc"

      integer        islate           ! This common is used to communicate with 
      common /slate/ islate(40)       ! the cernlib routine getenvf

C... local variables
      integer        
     &    i,                          !
     &    ioerr,                      ! Used in open calls
     &    iw
      character*256  env_trans        ! Tranlated environment name

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


c     Set random seeds by time of day. Pythia requires seed < 900,000,000
      if(mrpy(1) .eq. 0) then
        call get_ranseed_from_time(mrpy(1))
        mrpy(1) = mod(mrpy(1), 900000000)
      else if (mrpy(1).eq.-1) then
C
C       A value of -1 indicates that a file from the end of the last run 
C         should be read.
C
        call getenvf ('LUND_RAN_IN', env_trans)
        if (islate(1).eq.0) then 
          open (unit=55, file='LUND_RAN', form='UNFORMATTED', 
     &        status='OLD', iostat=ioerr)
          env_trans = 'LUND_RAN'
        else
          open (unit=55, file=env_trans,  form='UNFORMATTED',
     &        status='OLD', iostat=ioerr)
        endif
        if (ioerr.eq.0) then
          write (LNHOUT, 9002) env_trans 
          call pyrset (55, 0)          ! Sets random number based on file
          close (55)
          write (LNHOUT, 9004, iostat=ioerr) ( mrpy(iw), iw=1,6 )
          write (LNHOUT, 9005, iostat=ioerr) ( rrpy(iw), iw=1,100 )
          write (LNHOUT, 9006, iostat=ioerr) 
        else
          write (6, 9003) 
          stop
        endif
      endif
      return

 9002 format (' Reading random seed from ',A)
 9003 format (' Unable to read lund_ran.last. Aborting job. ')
 9004 format (' Last random numbers used by LUND: '/' '/' MRPY: ',6I7/
     &       ' RRPY: ' )
 9005 format (' ',10F8.5 ) 
 9006 format (' '/' ')

      END

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:58:35  eugenio
c Initial revision
c
c Revision 1.3  1998/07/09 21:00:23  garren
c for lund v6_115, herwig v5_9a, and isajet v7_37
c
c Revision 1.2  1998/06/25  15:49:01  bphyslib
c add all necessary changes from v3_3
c

