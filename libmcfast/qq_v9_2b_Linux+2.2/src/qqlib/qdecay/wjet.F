*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.15.03  by  Paul Avery
*CMZ :  1.03/71 01/12/93  11.09.54  by  Lynn Garren
*CMZ :  1.00/00 14/06/90  14.26.24  by  Paul Avery
*CMZ :          19/05/90  14.51.01  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE WJET(ECM,NDD,KQ,PQ,KID,XM,PTSIG)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ---------------------------------------------------------------------------
C    This routine generates qqbar jet decays of two arbitrarily flavored
C  quarks of invariant mass ECM. If the quarks come from W decay, you
C  should pass quark flavors appropriate for charged currents.
C    The jet axis is always the z axis. You must rotate and
C  boost the resulting system to get the particle momenta in the frame
C  of choice.
C  Variables with ** by them are required as inputs to WJET.
C**ECM : The invariant mass of the two quark system.
C**NDD : The number of daughters. The value of NDD returned by WJET
C        will be the total number of daughters including the 'D'.
C**KQ(1,1),KQ(2,1):  The array containing the flavors of the two quarks
C        involved in the decay.
C**PTSIG: The sigma of the PT distribution.
C  PQ:  The momenta of the daughters.
C  KID: Particle ID array for the daughters.
C  XM:  Array of masses for the daughters.
C  ---------------------------------------------------------------------------

#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqwjet.inc"

C     Calling variables
      INTEGER NDD
      INTEGER KQ(2,5), KID(30)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION ECM, PTSIG
      DOUBLE PRECISION XM(30), PQ(4,30)
#else
      REAL ECM, PTSIG
      REAL XM(30), PQ(4,30)
#endif
*
C     Local variables
      INTEGER LST, IT, NQJ, ISEED, JT, IFL2, JSGN, ITT, JTT, NJ
      INTEGER ITV(2,3), KP(30), IFL1(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION SIG, WMAX, PX2, PY2, Z, QMTS, GAMP, XXPT, TINYPT
      DOUBLE PRECISION PSA, PSB, DSGN
      DOUBLE PRECISION PX1(2), PY1(2), PMTS(2), W(2), WG(2), GAMM(2)
#else
      REAL SIG, WMAX, PX2, PY2, Z, QMTS, GAMP, XXPT, TINYPT
      REAL PSA, PSB
      REAL PX1(2), PY1(2), PMTS(2), W(2), WG(2), GAMM(2)
#endif

      COMMON/GCM/NJ(3),NQJ(3)
      COMMON/RANDM/ISEED
*
C     External declarations
      INTEGER KPART, KBPART
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS, ZDIST
      REAL RANP
#else
      REAL GETMAS, ZDIST, RANP
#endif
      EXTERNAL KPART, KBPART, GETMAS, ZDIST, RANP
*
      DATA TINYPT/1.0E-9/
C  ---------------------------------------------------------------------------


100   LST = NDD
      SIG = PTSIG

      DO 120 IT=1,2
        NQJ(IT)=  0
        IFL1(IT)= KQ(IT,1)
        PX1(IT) = 0.
        PY1(IT) = 0.
        W(IT)   = ECM
        WG(IT)  = ECM
        GAMM(IT)= 0.
120   CONTINUE

C  If the CM energy is low, generate only two primary mesons

      WMAX = BQMAS(IABS(IFL1(1)))+BQMAS(IABS(IFL1(2)))+PAR(IFR+10)
      IF(W(1)*W(2).LE.(WMAX-(PAR(IFR+10)-PAR(9))
     *     *RANP(ISEED))**2)GO TO 150

C  Choose a side. Generate a quark-antiquark pair and form a meson
130   LST = LST + 1

CKFR  JT=1.+2.*RANP(ISEED)   Avoid JT=3, 5-MAR-86
      JT=1
      IF(RANP(ISEED).GT.0.5) JT=2
      NQJ(JT)= NQJ(JT)+1

C    21-AUG-80
C   Allow baryon generation by also pulling out
C   of the vacuum diquark systems.
C   Hanne Kooy, 1-FEB-81, Syrcuse U.

C   Only allow baryon generation for U, D, S and C quarks.
C   Check if the now leading parent is a diquark.

      IF (IABS(IFL1(JT)).LT.10) GO TO 131

C  Since it is, form a baryon:
      IFL2=1+INT(RANP(ISEED)/PUD)

C   Determine the 3 quarks that make up the baryon
      JSGN=ISIGN(1,IFL1(JT))
      ITT=IABS(IFL1(JT))-9
      ITV(1,1)=IQFLV(1,ITT)*JSGN
      ITV(1,2)=IQFLV(2,ITT)*JSGN
      ITV(1,3)=IFL2*JSGN

C   Get baryon flavor
      KP(LST)=KBRFLV(IABS(IFL1(JT))-9,IFL2)

C   Get baryon type
      KID(LST)=KBPART(ITV)

C   Get right q qbar assignment
      IFL2=ISIGN(IFL2,IFL1(JT))
      GO TO 132

C   Not a diquark parent. See if next one will be if enough rapidity
C   is left over.
131   IF (W(JT).LT.WBAR) GO TO 133
      IF (FLIP.LT.RANP(ISEED)) GO TO 133
      IF (IABS(IFL1(JT)).GT.4) GO TO 133

C   Form a baryon again:
      CALL DIQFLV(IFL2)

C   Determine the 3 quarks that make up the baryon
      JSGN=ISIGN(1,IFL1(JT))
      ITV(1,1)=IQFLV(1,IFL2)*JSGN
      ITV(1,2)=IQFLV(2,IFL2)*JSGN
      ITV(1,3)=IFL1(JT)
      KP(LST)=KBRFLV(IFL2,IABS(IFL1(JT)))
      KID(LST)=KBPART(ITV)
      IFL2=ISIGN(IFL2+9,IFL1(JT))
      GO TO 132

C   Not a diquark parent or to be, so form a meson:

133   IFL2=ISIGN(1+INT(RANP(ISEED)/PUD),-IFL1(JT))
      KP(LST)=6*MAX0(IFL1(JT),IFL2)-MIN0(IFL1(JT),IFL2)-6
      KID(LST)=KPART(KP(LST),INT(PS1+RANP(ISEED)))
132   XM(LST)=GETMAS(KID(LST))

C   Generate PT and Z (note constraints). Weighting in GAMMA for IFR=2
      PMTS(3-JT)=(BQMAS(IABS(IFL1(3-JT)))+BQMAS(IABS(IFL2)))**2

140   CALL PTDIST(PX2,PY2,SIG)
      PMTS(JT)=XM(LST)**2+(PX1(JT)+PX2)**2+(PY1(JT)+PY2)**2
      IF(PMTS(1)+PMTS(2).GE.PAR(10)*W(1)*W(2)) GOTO 100
      Z=ZDIST(IFL1(JT),PMTS(JT)/(W(1)*W(2)),1.-PMTS(3-JT)/(W(1)*W(2)))
      IF(IFR.NE.2) GOTO 141
      QMTS=(BQMAS(IABS(IFL2))-BQMAS(7))**2+PX2**2+PY2**2
      GAMP=(1.-Z*W(JT)/WG(JT))*(GAMM(JT)+PMTS(JT)*WG(JT)/(Z*W(JT)))
      IF(GAMP/(QMTS+GAMP).LT.RANP(ISEED)) GOTO 140
      GAMM(JT)=GAMP
      WG(JT)=WG(JT)-Z*W(JT)
141   CONTINUE

C  Four-momentum for meson. Remaining flavor and momentum

      PQ(1,LST)=PX1(JT)+PX2
      PQ(2,LST)=PY1(JT)+PY2
      PQ(3,LST)=0.5*(Z*W(JT)-PMTS(JT)/(Z*W(JT)))*(-1.)**(JT+1)
      PQ(4,LST)=0.5*(Z*W(JT)+PMTS(JT)/(Z*W(JT)))
      IFL1(JT)=-IFL2
      PX1(JT)=-PX2
      PY1(JT)=-PY2
      W(1)=W(1)-PQ(4,LST)-PQ(3,LST)
      W(2)=W(2)-PQ(4,LST)+PQ(3,LST)

C  If enough energy left, continue generation

      WMAX=BQMAS(IABS(IFL1(1)))+BQMAS(IABS(IFL1(2)))+PAR(IFR+10)
      IF(W(1)*W(2).GE.WMAX**2) GOTO 130

C  Generate final quark-antiquark pair. Gives final two mesons

150   LST = LST + 2

C   Never end up with a diquark system at the end
      IF(IABS(IFL1(1)).GE.10.OR.IABS(IFL1(2)).GE.10)GOTO 100

C   Also never end up with leftovers of equal sign

      IF(IFL1(1)*IFL1(2).GT.0)GOTO 100

      IFL2=ISIGN(1+INT(RANP(ISEED)/PUD),-IFL1(1))
      KP(LST-1)=6*MAX0(IFL1(1),IFL2)-MIN0(IFL1(1),IFL2)-6
      KP(LST)=6*MAX0(IFL1(2),-IFL2)-MIN0(IFL1(2),-IFL2)-6
      CALL PTDIST(PX2,PY2,SIG)

      DO 160 JTT=1,2
        NQJ(JTT)=NQJ(JTT)+1
        KID(LST-2+JTT)=KPART(KP(LST-2+JTT),INT(PS1+RANP(ISEED)))
        XM(LST-2+JTT)=GETMAS(KID(LST-2+JTT))
        PQ(1,LST-2+JTT)=PX1(JTT)+PX2*(-1.)**(JTT+1)
        PQ(2,LST-2+JTT)=PY1(JTT)+PY2*(-1.)**(JTT+1)
        PMTS(JTT)=XM(LST-2+JTT)**2+PQ(1,LST-2+JTT)**2+PQ(2,LST-2+JTT)**2
160   CONTINUE

C  If too low energy, start over again:
C
C  The following code was added 5-sept-85
C  because of sqrt of 0 or neg # errors>> PAUL TIPTON

      XXPT=W(1)*W(2)
      IF(XXPT.LE.0.) XXPT=TINYPT
      IF(PMTS(1).LE.0.) PMTS(1)=TINYPT
      IF(PMTS(2).LE.0.) PMTS(2)=TINYPT

C     IF(SQRT(W(1)*W(2)).LE.SQRT(PMTS(1))+SQRT(PMTS(2)))GOTO 100

      IF(SQRT(XXPT).LE.SQRT(PMTS(1))+SQRT(PMTS(2)))GOTO 100
      PSA=W(1)*W(2)+PMTS(1)-PMTS(2)
      IF ( PSA**2-4.*W(1)*W(2)*PMTS(1) .LT. 0 ) GOTO 100
#if defined(NONCLEO_DOUBLE)
      DSGN = RANP(ISEED)-PAR(IFR+12)
      PSB=SIGN(DSQRT(PSA**2-4.*W(1)*W(2)*PMTS(1)),DSGN)
#else
      PSB=SIGN(SQRT(PSA**2-4.*W(1)*W(2)*PMTS(1)),
     *            RANP(ISEED)-PAR(IFR+12))
#endif
      PQ(3,LST-1)=0.25*((PSA+PSB)/W(2)-(PSA-PSB)/W(1))
      PQ(4,LST-1)=0.25*((PSA+PSB)/W(2)+(PSA-PSB)/W(1))
      PQ(3,LST)=0.5*(W(1)-W(2))-PQ(3,LST-1)
      PQ(4,LST)=0.5*(W(1)+W(2))-PQ(4,LST-1)
      NDD = LST
      RETURN
      END
