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
*CMZ :  1.04/00 16/09/94  02.30.35  by  Paul Avery
*CMZ :          07/12/93  12.18.17  by  Lynn Garren
      SUBROUTINE QQRDCY(LERR01)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ
C   Read QQ decay file
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqfile.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/qqluns.inc"

C-- Calling arguments
      LOGICAL LERR01

C-- Local variables
      INTEGER I, L, IL, MATRX
      INTEGER I1,I2,I3,IFIRST,KFIRST,NCHANK,NDAUK,KKSUMT,IDTYPK

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      LERR01 = .TRUE.

C--------------------------------------  Read in DEFAUL DECAY.DEC

       WRITE(LTTOQQ, 5050) FDECQQ
5050   FORMAT(/,' QQRDCY: Reading decay file ',A)
       CALL QQRFIL(FDECQQ, LERR01)
       IF(LERR01) THEN
         WRITE(LTTOQQ, 5066)
         WRITE(LOUTQQ, 5066)
5066     FORMAT(/,' QQRDCY: Error reading decay file',/)
         GOTO 9999
       ENDIF


C--- Sum the particle content of each decay mode for later usage

       DO 6000 I1=1,NPMXQQ

         IFIRST = IPLIST(1,I1)
         NCHANK = IPLIST(2,I1)

         DO 6010 I2=1,NCHANK

           KFIRST = MLLIST(2,IFIRST+I2-1)
           NDAUK  = MLLIST(1,IFIRST+I2-1)
           KKSUMT = 0

           DO 6020 I3=1,NDAUK

             IDTYPK = IDLIST(KFIRST+I3-1)
             IF(IDTYPK.LT.0.0) THEN
               KKSUMT = -1
               GOTO 6030
             ELSE
               KKSUMT = KKSUMT + IDTYPK
             ENDIF
 6020      CONTINUE

 6030      MLLIST(9,IFIRST+I2-1) = KKSUMT

 6010    CONTINUE
 6000  CONTINUE



C--- Fix up the tau matrx elements for non-KORALB decays

      IF(MODEL.NE.7) THEN
        DO 5010 IL=1,MCHANS
          MATRX = MLLIST(3,IL)
          IF(MATRX.LT.2001) GOTO 5010
          IF(MATRX.GT.2050) GOTO 5010
            IF(MATRX.EQ.2001.OR.MATRX.EQ.2002) THEN
                        MLLIST(3,IL) = 1
            ELSE
                        MLLIST(3,IL) = 0
            ENDIF
 5010    CONTINUE
      ENDIF

C     Normal exit
      LERR01 = .FALSE.
      RETURN

C     Error exit
9999  RETURN
      END
