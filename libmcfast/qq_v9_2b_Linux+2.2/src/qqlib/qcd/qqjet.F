*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.11.06  by  Paul Avery
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE QQJET(IFL,ECM)
C.......................................................................
C.
C. QQJET -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : QQPROP MCGEN
C.
C. Calls     : DIQFLV PTDIST
C. Called    : EVTGEN QQGGEN GGGJET
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*- Argument declarations
      INTEGER IFL
      REAL    ECM

*- External declarations
      INTEGER  KBPART, KPART
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS, ZDIST
      REAL     RANP
#else
      REAL     GETMAS, ZDIST, RANP
#endif
      EXTERNAL KBPART, KPART, GETMAS, ZDIST, RANP
*
*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"

      INTEGER NJ, NQJ
      INTEGER ISEED
      COMMON/GCM/NJ(3),NQJ(3)
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQJET' )
*
      INTEGER  ITV(2,3)
      INTEGER  IFL1(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PX1(2),PY1(2),PMTS(2),W(2),WG(2),GAMM(2)
#else
      REAL     PX1(2),PY1(2),PMTS(2),W(2),WG(2),GAMM(2)
#endif

      INTEGER  I, JT, ISGNJT, IFL2, JSGN, ITT, JS
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION TESTE, WMAX, PX2, PY2, Z, QMTS, GAMP, SGNJT
      DOUBLE PRECISION TSTW12, PSA, PSB, DSGN
#else
      REAL     TESTE, WMAX, PX2, PY2, Z, QMTS, GAMP, SGNJT
      REAL     TSTW12, PSA, PSB
#endif
*
*- Executable code starts here
*
*
C-- Initial values, user and internal calls, respectively
  100 IF(IST.GT.0) GOTO 111
      NC=2

C      I=0
C-- Don't allow i to be reset
      I=LASTN
      DO 110 JT=1,2
         NQJ(JT)=0
         ISGNJT = ISIGN(1,3-2*JT)
         KC(JT)=IFL*ISGNJT
CPA      KC(JT)=IFL*(-1)**(JT+1)
#if defined(NONCLEO_DOUBLE)
         PC(JT,1)=0.D0
         PC(JT,2)=0.D0
         TESTE   = (0.5*ECM)**2-QMAS(IABS(IFL))**2
         PC(JT,3) = 1.D-20
#else
         PC(JT,1)=0.
         PC(JT,2)=0.
         TESTE   = (0.5*ECM)**2-QMAS(IABS(IFL))**2
         PC(JT,3) = 1.E-20
#endif

C protect against real funnies
         IF(TESTE.GT.0) THEN
            PC(JT,3)=SQRT((0.5*ECM)**2-QMAS(IABS(IFL))**2)*ISGNJT
CPA         PC(JT,3)=SQRT((0.5*ECM)**2-QMAS(IABS(IFL))**2)*(-1.)**(JT+1)
         ENDIF

         PC(JT,4)=0.5*ECM
         IFL1(JT)=IFL*ISGNJT
CPA      IFL1(JT)=IFL*(-1)**(JT+1)
         PX1(JT)=0.
         PY1(JT)=0.
         W(JT)=ECM
         WG(JT)=ECM
  110    GAMM(JT)=0.

      IF(IST.LT.0) RETURN

  111 IF(IST.LE.0) GOTO 121
      I=N
      DO 120 JT=1,2
         NQJ(JT)=0
         IFL1(JT)=K(248+JT,1)
         PX1(JT)=P(248+JT,1)
         PY1(JT)=P(248+JT,2)
         W(JT)=P(248+JT,3)
         WG(JT)=P(248+JT,4)
  120    GAMM(JT)=P(248+JT,5)

  121 CONTINUE

C-- If the cm energy is low, generate only two primary mesons
      WMAX=QMAS(IABS(IFL1(1)))+QMAS(IABS(IFL1(2)))+PAR(IFR+10)
      IF(W(1)*W(2) .LE. (WMAX-(PAR(IFR+10)-PAR(9))*RANP(ISEED))**2)
     *      GOTO 150

C-- Choose side. generate a quark-antiquark pair. form a meson

  130 I=I+1

CKFR  JT=1.+2.*RANP(ISEED)      !AVOID JT=3, 5-MAR-86
      JT=1
      IF(RANP(ISEED).GT.0.5) JT=2
CKFR
C 21-AUG-80
      NQJ(JT)= NQJ(JT)+1

C-- Allow baryon generation by also pulling out
C-- of the vacuum diquark systems.
C        HANNE KOOY, 1-FEB-81, SYRACUSE U.


C-- Only allow baryon generation for U, D, S, C quarks
C-- check if the now leading parent is a diquark
      IF (IABS(IFL1(JT)).LT.10) GO TO 131

C-- Since it is form a baryon
      IFL2=1+INT(RANP(ISEED)/PUD)

C-- Determine the 3 quarks that make up the baryon
      JSGN=ISIGN(1,IFL1(JT))
      ITT=IABS(IFL1(JT))-9
      ITV(1,1)=IQFLV(1,ITT)*JSGN
      ITV(1,2)=IQFLV(2,ITT)*JSGN
      ITV(1,3)=IFL2*JSGN
C-- Get baryon flavor
      K(I,1)=KBRFLV(IABS(IFL1(JT))-9,IFL2)
C-- Get baryon type
      K(I,2)=KBPART(ITV)
C-- Get right q qbar assignment
      IFL2=ISIGN(IFL2,IFL1(JT))
      GO TO 132

C-- Not a diquark parent. see if next one will be
C-- If enough rapidity is left over

131   IF (W(JT).LT.WBAR)       GO TO 133
      IF (FLIP.LT.RANP(ISEED))  GO TO 133
      IF (IABS(IFL1(JT)).GT.4) GO TO 133

C-- Form a baryon again
      CALL DIQFLV(IFL2)

C-- Determine the 3 quarks that make up the baryon
      JSGN=ISIGN(1,IFL1(JT))
      ITV(1,1)=IQFLV(1,IFL2)*JSGN
      ITV(1,2)=IQFLV(2,IFL2)*JSGN
      ITV(1,3)=IFL1(JT)
      K(I,1)=KBRFLV(IFL2,IABS(IFL1(JT)))
      K(I,2)=KBPART(ITV)
      IFL2=ISIGN(IFL2+9,IFL1(JT))
      GO TO 132

C-- Not a diquark parent or to be, so form meson
133   IFL2=ISIGN(1+INT(RANP(ISEED)/PUD),-IFL1(JT))
      K(I,1)=6*MAX0(IFL1(JT),IFL2)-MIN0(IFL1(JT),IFL2)-6
      K(I,2)=KPART(K(I,1),INT(PS1+RANP(ISEED)))

  132 P(I,5)=GETMAS(K(I,2))

C-- Generate PT and Z (note constraints). weighting in gamma for IFR=2
      PMTS(3-JT)=(QMAS(IABS(IFL1(3-JT)))+QMAS(IABS(IFL2)))**2

  140 CALL PTDIST(PX2,PY2,SIGMA)
      PMTS(JT)=P(I,5)**2+(PX1(JT)+PX2)**2+(PY1(JT)+PY2)**2
      IF(PMTS(1)+PMTS(2).GE.PAR(10)*W(1)*W(2)) GOTO 100
      Z=ZDIST(IFL1(JT),PMTS(JT)/(W(1)*W(2)),1.-PMTS(3-JT)/(W(1)*W(2)))
      IF(IFR.NE.2) GOTO 141
      QMTS=(QMAS(IABS(IFL2))-QMAS(7))**2+PX2**2+PY2**2
      GAMP=(1.-Z*W(JT)/WG(JT))*(GAMM(JT)+PMTS(JT)*WG(JT)/(Z*W(JT)))
      IF(GAMP/(QMTS+GAMP).LT.RANP(ISEED)) GOTO 140
      GAMM(JT)=GAMP
      WG(JT)=WG(JT)-Z*W(JT)

  141 CONTINUE

C-- Four-momentum for meson. remaining flavour and momentum
      P(I,1)=PX1(JT)+PX2
      P(I,2)=PY1(JT)+PY2
      P(I,3)=0.5*(Z*W(JT)-PMTS(JT)/(Z*W(JT)))*SIGN(1.,1.5-JT)
CPA   P(I,3)=0.5*(Z*W(JT)-PMTS(JT)/(Z*W(JT)))*(-1.)**(JT+1)
      P(I,4)=0.5*(Z*W(JT)+PMTS(JT)/(Z*W(JT)))
      IFL1(JT)=-IFL2
      PX1(JT)=-PX2
      PY1(JT)=-PY2
      W(1)=W(1)-P(I,4)-P(I,3)
      W(2)=W(2)-P(I,4)+P(I,3)

C-- If enough energy left, continue generation
      WMAX=QMAS(IABS(IFL1(1)))+QMAS(IABS(IFL1(2)))+PAR(IFR+10)
      IF(W(1)*W(2).GE.WMAX**2) GOTO 130

C-- Generate final quark-antiquark pair. gives final two mesons
  150 I=I+2

C-- Never end up with a diquark system at the end
      IF(IABS(IFL1(1)).GE.10.OR.IABS(IFL1(2)).GE.10)GOTO 100
C-- Also never end up with leftovers of equal sign
      IF(IFL1(1)*IFL1(2).GT.0)GOTO 100

      IFL2=ISIGN(1+INT(RANP(ISEED)/PUD),-IFL1(1))
      K(I-1,1)=6*MAX0(IFL1(1),IFL2)-MIN0(IFL1(1),IFL2)-6
      K(I,1)=6*MAX0(IFL1(2),-IFL2)-MIN0(IFL1(2),-IFL2)-6
      CALL PTDIST(PX2,PY2,SIGMA)

      DO 160 JT=1,2
         NQJ(JT)=NQJ(JT)+1
         SGNJT = SIGN(1.,1.5-JT)
         K(I-2+JT,2)=KPART(K(I-2+JT,1),INT(PS1+RANP(ISEED)))
         P(I-2+JT,5)=GETMAS(K(I-2+JT,2))
         P(I-2+JT,1)=PX1(JT)+PX2*SGNJT
CPA      P(I-2+JT,1)=PX1(JT)+PX2*(-1.)**(JT+1)
         P(I-2+JT,2)=PY1(JT)+PY2*SGNJT
CPA      P(I-2+JT,2)=PY1(JT)+PY2*(-1.)**(JT+1)
  160    PMTS(JT)=P(I-2+JT,5)**2+P(I-2+JT,1)**2+P(I-2+JT,2)**2

C-- If too low energy, start all over. else choose one of two solutions

      TSTW12=W(1)*W(2)
#if defined(NONCLEO_DOUBLE)
      IF( (W(1).LE.0.).OR.(W(2).LE.0.) ) TSTW12=1.D-12
#else
      IF( (W(1).LE.0.).OR.(W(2).LE.0.) ) TSTW12=1.E-12
#endif
      IF(SQRT(TSTW12).LE.SQRT(PMTS(1))+SQRT(PMTS(2))) GOTO 100
      PSA=W(1)*W(2)+PMTS(1)-PMTS(2)
#if defined(NONCLEO_DOUBLE)
      DSGN = RANP(ISEED)-PAR(IFR+12)
      PSB=SIGN(SQRT(PSA**2-4.*W(1)*W(2)*PMTS(1)),DSGN)
#else
      PSB=SIGN(SQRT(PSA**2-4.*W(1)*W(2)*PMTS(1)),
     *    RANP(ISEED)-PAR(IFR+12))
#endif
      P(I-1,3)=0.25*((PSA+PSB)/W(2)-(PSA-PSB)/W(1))
      P(I-1,4)=0.25*((PSA+PSB)/W(2)+(PSA-PSB)/W(1))
      P(I,3)=0.5*(W(1)-W(2))-P(I-1,3)
      P(I,4)=0.5*(W(1)+W(2))-P(I-1,4)
      N=I
C     IF(IST.EQ.0) CALL DECAYS

      RETURN
      END
