*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.2  1996/08/07 09:55:59  clib
* Bug fix from pck: let LUND decay Y(2S)
*
* Revision 1.1.1.1  1994/10/08  02:21:34  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  16.28.49  by  Paul Avery
*CMZ :  1.03/57 15/02/93  15.00.16  by  Peter C Kim
*CMZ :  1.03/36 16/12/91  19.43.39  by  Peter C Kim
*CMZ :  1.03/31 11/11/91  20.48.01  by  Unknown
*CMZ :  1.03/15 22/07/91  21.12.25  by  Peter C Kim
*CMZ :  1.03/12 02/07/91  12.22.17  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  14.57.12  by  Peter C Kim
*CMZ :  1.02/00 05/02/91  17.54.03  by  Peter C Kim
*-- Author :

      SUBROUTINE QILUND
C------------------------------------------------------------------
C  Initializes the LUND parameters and read in the particle table
C
C  Added initializaion related to narrow resonance production
C  with radiative tails / beam smearing.              PCK  28/3/91
C------------------------------------------------------------------
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqtrak.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqbmst.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/jetscl.inc"
#include "geant/gcdes/ludat1.inc"
#include "geant/gcdes/ludat3.inc"
#include "qqlib/seq/ludatr.inc"

C-- External variables

      INTEGER QQRINP
      EXTERNAL QQRINP

C-- Local variables

      INTEGER I,QCODE
      REAL RESMAS,WRESON,ERESOL,ECMMAX,ECMMIN,ERES2,RATMX,EFNL,CROSS
      REAL TRAD,RATIOC
      COMMON /MOD14/ RESMAS,WRESON,ECMMAX,ECMMIN,TRAD,RATMX,ERES2

C=====================================================================

C  Get unit numbers -- Eliminated 10-9-93 (PA)

CPA      CALL DVLUNS(LTTIQQ, LTTOQQ, LOUTQQ, LTMPQQ, LTINQQ, LTOUQQ)

C--- Update the particle list and decay table

      IF(LUDTAB .NE. ' ') THEN

#if defined(CLEO_VAX)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD',READONLY,SHARED)
#endif
#if defined(CLEO_UNIX)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD')
#endif
#if defined(CLEO_IBM)
      OPEN(UNIT=LTMPQQ, FILE=LUDTAB, STATUS='OLD')
#endif

        WRITE(LTTOQQ,201) LUDTAB
 201    FORMAT(/,' LUND Decay table :  ',A)
        CALL LUUPDA(2,LTMPQQ)

      ENDIF

C-- Set LUND parameters

      MSTJ(101) = QCDCOR
      MSTJ(104) = NFLAV
      MSTJ(107) = ISTRAD

      MSTJ(11)  = LFRAG

      IF(LFRAG.EQ.1) THEN
         PARJ(41) = LUNDAA
         PARJ(42) = LUNDBB
      ENDIF

      IF (LFRAG.EQ.2.OR.LFRAG.EQ.3) THEN
         PARJ(54) = EPSC
         PARJ(55) = EPSB
      ENDIF

      PARJ(11) = MSPIN(1)
      PARJ(12) = MSPIN(2)
      PARJ(13) = MSPIN(3)
      PARJ(14) = MSPIN(4)
      PARJ(15) = MSPIN(5)
      PARJ(16) = MSPIN(6)
      PARJ(17) = MSPIN(7)

C-- Modify the minimum value where the fragmentation stopps.

      PARJ(33) = EMINFX

C-- Set the intial Random number

      MRLU(1) = IRAND

C-- Turn off the particle decay in LUND,  will be decyed in QQ.
C   Only the Quokonium resonances are decayed by LUND.

      IF(LUNDEC.NE.0) GOTO 3

        MDCY( 15,1) = 0

        DO 1 I=101,500
 1      MDCY(I,1) = 0

        DO 2 I=1,5
          MDCY(113+I,1) = 1
          MDCY(133+I,1) = 1
          MDCY(153+I,1) = 1
          MDCY(173+I,1) = 1
          MDCY(193+I,1) = 1
          MDCY(213+I,1) = 1
 2      CONTINUE

        MDCY(231,1) = 1
        MDCY(235,1) = 1

        MDCY(241,1) = 1
        MDCY(242,1) = 1
        MDCY(243,1) = 1
        MDCY(244,1) = 1

        MDCY(260,1) = 1
        MDCY(261,1) = 1
        MDCY(262,1) = 1
        MDCY(263,1) = 1
        MDCY(264,1) = 1
        MDCY(265,1) = 1
        MDCY(266,1) = 1
        MDCY(267,1) = 1


 3    CONTINUE


C----------------------------------------------------------------

C-- Calculate paramters used for resonance production
C
C      e+e-  -->  Y(nS)

      IF(MODEL.NE.14) GOTO 999

        QCODE = QQRINP(CRESON)
        RESMAS = AMASS(QCODE)
        WRESON = RWIDTH(QCODE)

C-- only narrow resonances are initialized

      IF(WRESON.GE.0.0001) GOTO 999

      TRAD = (2.0/3.141592/137.035) * (2.0*LOG(ECM/0.000511)-1.0)

C-- Find the maximum.

      ERESOL = SQRT(BWPSQQ**2+BWNGQQ**2)
      ERES2  = ERESOL*ERESOL
      ECMMAX = ECM + 3.0*ERESOL
      ECMMIN = ECM - 3.0*ERESOL

      IF(ECMMIN.LE.RESMAS) THEN

        ECMMIN = RESMAS + 0.0001
        DO 10 I=1,100
          EFNL  = RESMAS + FLOAT(I)*0.0001
          CROSS = EXP(-(ECM-EFNL)**2.0*0.5/ERES2) * (2.0/EFNL)**TRAD
     *                                / (EFNL - RESMAS)**(1.-TRAD)
          IF(I.EQ.1) THEN
               RATMX = CROSS
          ELSE
               RATIOC = CROSS/RATMX
               IF(RATIOC.LT.0.1) THEN
                 ECMMAX = EFNL
                 GOTO 15
               ENDIF
          ENDIF
 10     CONTINUE
 15     CONTINUE
        RATMX = RATMX * 1.2

      ELSE

        RATMX = (2.0/ECM)**TRAD/(ECM-RESMAS)**(1.-TRAD) * 1.2

      ENDIF

 999  RETURN
      END
