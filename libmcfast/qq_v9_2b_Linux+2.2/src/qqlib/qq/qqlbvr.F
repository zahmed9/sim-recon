*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/70 18/10/93  20.54.36  by  Peter C Kim
*-- Author :    Peter C Kim   18/10/93

      SUBROUTINE QQLBVR
C.......................................................................
C.
C. QQLBVR - { Write the version # extracted from the TITLE }
C.
C. Inputs    : None
C. Outputs   : None
C. COMMON    : None
C.
C. Calls     : LENOCC
C. Called    : QQINPT
C. Author    : Peter C Kim  18/10/93  19.02.27
C.
C.......................................................................
#if defined(CLEO_TYPECHECK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/qqluns.inc"
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQLBVR' )

      INTEGER  LENOCC
      EXTERNAL LENOCC

*
* CTITLE - TITLE card
* VERS   - Version rr.vv floating
* ILEV   - Level   ll    integer
* IDATE  - Release date yymmdd integer
* TIME   - Release time hh.ss  floating

      CHARACTER*80    CTITLE
      INTEGER         ILEV  , IDATE
      REAL            VERS  , TIME
*
      INTEGER ISLASH, IERR
*
C---------------------- Executable code starts here --------------------
C
C== Extract version info. from TITLE
C
      CTITLE = ' '
      WRITE(CTITLE,1000)
      ISLASH = INDEX(CTITLE,'/')

      IF( ISLASH.LE.0 ) THEN
         WRITE(LTTOQQ,10000)
      ELSE

* Release/version
         VERS = 0.0
         READ( CTITLE(ISLASH-5:ISLASH-1),  1010, IOSTAT=IERR ) VERS
         IF( IERR.NE.0 ) THEN
            WRITE(LTTOQQ,10010)
         ENDIF
* Level
         ILEV = 0
         READ( CTITLE(ISLASH+1:ISLASH+2),  1020, IOSTAT=IERR ) ILEV
         IF( IERR.NE.0 ) THEN
            WRITE(LTTOQQ,10020)
         ENDIF
* Date
         IDATE = 0
         READ( CTITLE(ISLASH+5:ISLASH+10), 1030, IOSTAT=IERR ) IDATE
         IF( IERR.NE.0 ) THEN
            WRITE(LTTOQQ,10030)
         ENDIF
* Time
         TIME = 0.0
         READ( CTITLE(ISLASH+13:ISLASH+17),1040, IOSTAT=IERR ) TIME
         IF( IERR.NE.0 ) THEN
            WRITE(LTTOQQ,10040)
         ENDIF
* Print

      WRITE(LTTOQQ,9000) VERS,ILEV,IDATE,TIME
9000  FORMAT(' QQLIB',2X,'Version',2X,F5.2,'/',I3,3X, I8,2X,F5.2,
     *       ' P Kim', 5X, 'MC Event Generator')

      ENDIF
C
      RETURN
*
1000  FORMAT(
     + 40H CPP_TITLE                 
     + )
1010  FORMAT(F5.2)
1020  FORMAT(I2)
1030  FORMAT(I6)
1040  FORMAT(F5.2)

10000 FORMAT(' Illegal TITLE card format' )
10010 FORMAT(' Error decoding version number' )
10020 FORMAT(' Error decoding level   number' )
10030 FORMAT(' Error decoding version date' )
10040 FORMAT(' Error decoding version time' )
      END
#include "TITLE.qqlib"
