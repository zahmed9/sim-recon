*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:51  eugenio
* Initial revision
*
* Revision 1.2  1995/04/25  13:55:08  zfiles
* Get 2-photon group version of modusr rather than dummy
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 08/08/90  11.01.55  by  Paul Avery
*CMZ :          19/05/90  14.41.36  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE MODUSR
C-----------------------------------------------------------------------
C  Since only the 2-photon group is using the MODUSR option, we replace
C  the blank subtroutine with the version obtained from MBS. (PCK 4/95)
C-----------------------------------------------------------------------
C
C  RAF's attempt to readin a file of initial particles
C.  The file tobe read from should be assigned to MODFIL:
C.  NENTRS   - number of entries in this set
C.  IENTRY   - This entry
C.  PIDTYP   - PID code for this entry
C.  PTHIS(4) - Four momentum for this entry
C.
C.  LUNDAT   - Input file unit number
C.  NTHOPN   - Number of times MODFIL: is rewound
C.  NERR     - Number of errors sofar
C.  LFIRST   - Flag to make first time call


#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqmxcp.inc"
#include "seq/clinc/qqbmst.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "seq/clinc/qqipcd.inc"
*

      CHARACTER*(*)  CRNAME
      PARAMETER(     CRNAME  =  'MODUSR' )
C
      REAL     PTHIS(4)
      INTEGER  NENTRS, IENTRY, PIDTYP, LUNDAT, NTHOPN, NERR
      LOGICAL  LFIRST
C
      DATA  LFIRST/.TRUE./
C
      IF(LFIRST)THEN
        LUNDAT = 30
C. Get unused unit number
        CALL QQGLUN(LUNDAT)
C
C       Initial opening of input file.

#if defined(CLEO_VAX)
      OPEN(UNIT=LUNDAT,FILE='QQRDIN.QQIN',
     *                 STATUS='OLD',READONLY,SHARED)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LUNDAT,FILE='QQRDIN.QQIN',STATUS='OLD')
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LUNDAT,FILE='QQRDIN.QQIN',STATUS='OLD')
#endif
        LFIRST = .FALSE.
      ENDIF
C
C     Get number of particle entries for this event
 100  READ(LUNDAT,8000,ERR=7000,END=3000) NENTRS
      WRITE(6,*)  ' NENTRS = ', NENTRS

      IF(NENTRS .LT. 1)GOTO 7001
      DO 10 IENTRY = 1, NENTRS
        READ(LUNDAT,8001,ERR=7002,END=3000)PIDTYP,PTHIS
C       FILL COMMONS
        WRITE(6,*) ' PIDTYP = ', PIDTYP
        WRITE(6,*) '   ',  PTHIS(1),PTHIS(2),PTHIS(3),PTHIS(4)
        N = IENTRY
        K(N,2) = PIDTYP
        P(N,1) = PTHIS(1)
        P(N,2) = PTHIS(2)
        P(N,3) = PTHIS(3)
        P(N,4) = PTHIS(4)
        P(N,5) = AMASS(PIDTYP)
  10  CONTINUE
      CALL DECADD(.FALSE.)

C
C     RETURN
      GOTO 9000
 3000 REWIND LUNDAT
      NTHOPN = NTHOPN + 1
      WRITE(LOUTQQ, 8006) NTHOPN
      WRITE(6     , 8006) NTHOPN
      GOTO 100
C
C ERROR MESSAGES:
 7000 WRITE(LOUTQQ, '('' Error reading MODFIL: NENTRS entry '')')
      WRITE(6     , '('' Error reading MODFIL: NENTRS entry '')')
      STOP
 7001 WRITE(LOUTQQ, '('' Error reading MODFIL: NENTRS < 1 '')')
      WRITE(6     , '('' Error reading MODFIL: NENTRS < 1 '')')
      NERR = NERR + 1
      GOTO 7999
 7002 WRITE(LOUTQQ,'('' Error reading MODFIL: PIDTYP and P4 '')')
      WRITE(6     , '('' Error reading MODFIL: PIDTYP and P4 '')')
      WRITE(LOUTQQ,'('' Will try to find next event in listing '')')
      WRITE(6     , '('' Will try to find next event in listing '')')
      NERR = NERR + 1
C
C EXIT ERROR MESSAGES
 7999 CONTINUE
      IF(NERR .GT. 100)THEN
       WRITE(LOUTQQ, '('' Over 100 READ errors for modfil '')')
       WRITE(6,      '('' Over 100 READ errors for modfil '')')
       WRITE(LOUTQQ, '('' Somethings way wrong, will stop '')')
       WRITE(6,      '('' Somethings way wrong, will stop '')')
       STOP
      ENDIF
C END ERROR MESAGGES:
      GOTO 100
C
C FORMATS::
 8000 FORMAT(10X,I3)
 8001 FORMAT(1X, I6, E12.4, E12.4, E12.4, E12.4)
 8006 FORMAT(5X,'**** REWIND INPUT FILE FOR THE ',I5,' TIME. ****')
C     For write statement to be used with line 8000 read FORMAT
 8010 FORMAT(1X,'NENTRS = ',I3)
C
C ALL EXIT HERE::
 9000 CONTINUE
      RETURN
      END
