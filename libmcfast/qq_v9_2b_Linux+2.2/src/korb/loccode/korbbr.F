*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.02/00 17/11/94  10.00.52  by  Alan J. Weinstein
*CMZ :  1.02/00 05/03/91  15.37.43  by  Peter C Kim
*-- Author :    Alan Weinstein  23/12/90
      SUBROUTINE KORBBR
C.......................................................................
C.
C. KORBBR - set up KORALB in QQ environment.
C.
C. Inputs    : None
C.           :
C. Outputs   : None
C.
C. COMMON    :
C.
C. Calls     : KORALB(-1)
C. Called    : MODINI
C. Author    : Alan Weinstein 23/12/90
C.
C. Detailed description
C.   Ininitialize KORALB, with parameters from namelist.
C.
C. NAMELIST removed;  FFREAD is done in QQINPT
C. Parameter initialization moved to QBINIT
C. /KORBCM/ common created.                         Mar, 1991  PCK
C.......................................................................
*SELF,IF=TYPECHEK.
      IMPLICIT NONE
*SELF.
 
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/korbcm.inc"
#include "qqlib/seq/qqluns.inc"
 
C-- Local variabels
 
      REAL PB1(4),PB2(4),XPR(40),ENE,AMZ,AMNUTA,AMFIN
      INTEGER NPR(40),INRAN,IRAND1,IRAND2,I,KFB
 
C KORALB output unit
      COMMON / INOUT / NINP,NOUT
      INTEGER NINP,NOUT
 
      COMMON / IDPART / IA1
      INTEGER IA1
 
C Set KORALB output Lun (KoralB hard codes this to 6)
      NOUT = LTTOQQ
 
C Set A1 to be lund type 40
      IA1 = 40
 
C Beam radiation should be turned off
      IF (BMRAD) THEN
        WRITE(NOUT,101)
  101   FORMAT(' KORBBR: You set BMRAD = T. Set KEYRAD=1 instead.'
     1        ,' Setting BMRAD = F.')
        BMRAD = .FALSE.
      END IF
 
C Get random number seed for KORALB
       CALL QQRNGT(IRAND1, IRAND2)
C This initializes the RNF100 generator
      INRAN = IRAND1
C This initializes the RANMAR generator
      CALL RMARIN(INRAN,0,0)
 
C Give Koralb the mean ECM
      ENE = BEAMQQ
      DO 5 I=1,3
      PB1(I)=0
   5  PB2(I)=0
      PB1(3)=ENE
      PB2(3)=-ENE
      PB1(4)=ENE
      PB2(4)=ENE
C Get tau-neutrino mass
      AMNUTA=AMASS(17)
      AMZ   =AMASS(2)
C MASS OF THE FINAL STATE QUARK (QUARK MODES ONLY)
      AMFIN=2.
 
      NPR(1)=KSPIN
      NPR(2)=INRAN
      NPR(3)=KEYGSW
      NPR(4)=KEYRAD
      NPR(5)=0
      NPR(6)=0
      NPR(7)=ITFIN
      NPR(8)=ITDKRC
      XPR(1)=AMZ
      XPR(6)=SINW2
      XPR(4)=KORBGV
      XPR(5)=KORBGA
      XPR(8)=AMNUTA
      XPR(11)=KORXK0
      XPR(14)=AMFIN
      KFB=-11
C
C initialize KoralB
      CALL KORALB(-1,KFB,PB1,KORBE1,-KFB,PB2,KORBE2,XPR,NPR)
C     **********************************************
C
      RETURN
      END
