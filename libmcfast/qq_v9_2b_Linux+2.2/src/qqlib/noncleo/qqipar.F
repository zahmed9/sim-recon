*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.45.16  by  Peter C Kim
*-- Author :
      SUBROUTINE QQIPAR

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Set default control variables for QQ
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqfile.inc"
#include "qqlib/seq/qqmisc.inc"
#include "qqlib/seq/qqluns.inc"

C-- local variables
      CHARACTER FTEMP*80
      LOGICAL LFILE

#if defined(CLEO_VAX)
      INCLUDE '($SSDEF)'
      INTEGER ISTAT,TRANSLATE_LOGICAL
#endif

C-----------------------------------------------------------------------
C-- Default decay tables
      FTAPQQ = ' '
      FCTLQQ = ' '

C-- Decode decay table names if not already defined
      FTEMP = ' '
      IF(FDECQQ.EQ.' ')THEN
#if defined(CLEO_VAX)
        ISTAT = TRANSLATE_LOGICAL('QQ_DECAY_FILE',FTEMP)
        IF(ISTAT .EQ. SS$_NORMAL)THEN
          FDECQQ = FTEMP
        ELSE
          FDECQQ = 'DECAY.DEC'
          WRITE(LTTOQQ,5002)
        ENDIF
#endif
#if defined(CLEO_UNIX)
        CALL GETENV('QQ_DECAY_FILE',FTEMP)
        IF(FTEMP.EQ.' ')THEN
          FDECQQ = 'DECAY.DEC'
          WRITE(LTTOQQ,5002)
        ELSE
          FDECQQ = FTEMP
        ENDIF
#endif
      ENDIF
      WRITE(LTTOQQ,5004) FDECQQ
      INQUIRE(FILE=FDECQQ,EXIST=LFILE)
      IF(.NOT.LFILE) WRITE(LTTOQQ,5007) FDECQQ
      FTEMP = ' '
      IF(NEWDEC.EQ.' ')THEN
#if defined(CLEO_VAX)
        ISTAT = TRANSLATE_LOGICAL('QQ_USER_FILE',FTEMP)
        IF(ISTAT .EQ. SS$_NORMAL)THEN
          NEWDEC = FTEMP
        ELSE
          NEWDEC = ' '
          WRITE(LTTOQQ,5003)
        ENDIF
#endif
#if defined(CLEO_UNIX)
        CALL GETENV('QQ_USER_FILE',FTEMP)
        IF(FTEMP.EQ.' ')THEN
          NEWDEC = ' '
          WRITE(LTTOQQ,5003)
        ELSE
          NEWDEC = FTEMP
        ENDIF
#endif
      ENDIF
      IF(NEWDEC.NE.' ')THEN
        WRITE(LTTOQQ,5005) NEWDEC
        INQUIRE(FILE=NEWDEC,EXIST=LFILE)
        IF(.NOT.LFILE) WRITE(LTTOQQ,5007) NEWDEC
      ENDIF

      RETURN
5002  FORMAT(' QQIPAR:  QQ_DECAY_FILE is undefined'/
     1       '          decay file will be set to DECAY.DEC')
5003  FORMAT(' QQIPAR:  no QQ_USER_FILE is defined')
5004  FORMAT(' QQIPAR:  QQ_DECAY_FILE is ',A80)
5005  FORMAT(' QQIPAR:  QQ_USER_FILE is ',A80)
5007  FORMAT(' QQIPAR:  WARNING file ',A80,' does not exist')
      END
