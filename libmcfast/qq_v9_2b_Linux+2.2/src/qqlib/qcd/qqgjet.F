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
*CMZ :  1.04/00 22/09/94  00.10.58  by  Paul Avery
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE QQGJET(IFL,ECM,X1,X2)
C.......................................................................
C.
C. QQGJET -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : QQPROP MCGEN
C.
C. Calls     : QQJET ROTBST
C. Called    : QQGGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*- Argument declarations
      INTEGER IFL
#if defined(NONCLEO_DOUBLE)
      REAL    ECM
      DOUBLE PRECISION X1, X2
#else
      REAL    ECM, X1, X2
#endif

*- External declarations
      INTEGER  KPART
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS, ZDIST
      REAL     RANP
#else
      REAL     GETMAS, ZDIST, RANP
#endif
      EXTERNAL KPART, GETMAS, ZDIST, RANP
*
*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*SEQ,LOCDSEQ. -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QQGJET' )
*
      INTEGER IFLQ(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION SA(2),CA(2),W(2,2),PX(2),PY(2),Z(2,2)
      DOUBLE PRECISION QMTS(2),GAMM(2)
*
      DOUBLE PRECISION THEQ, HA, HB, HC, HD, HE
#else
      REAL    SA(2),CA(2),W(2,2),PX(2),PY(2),Z(2,2),QMTS(2),GAMM(2)
*
      REAL    THEQ, HA, HB, HC, HD, HE
#endif
      INTEGER JS
*
*- Executable code starts here
*
*
C-- Initial values (gluon along z axis, fastest quark px>0)
      NC=3
      KC(1)=IFL
      KC(2)=-IFL
      KC(3)=0
      PC(1,4)=0.5*X1*ECM
      PC(2,4)=0.5*X2*ECM
      PC(3,4)=0.5*(2.-X1-X2)*ECM
      PC(1,2)=0.
      PC(2,2)=0.
      PC(3,2)=0.
      PC(3,3)=PC(3,4)
      PC(3,1)=0.
      PC(1,3)=(PC(2,4)**2-PC(1,4)**2-PC(3,4)**2)/(2.*PC(3,4))
      PC(1,1)=SQRT(PC(1,4)**2-PC(1,3)**2-QMAS(IABS(IFL))**2)
      PC(2,3)=-PC(1,3)-PC(3,3)
      PC(2,1)=-PC(1,1)-PC(3,1)
      IF(IST.LT.0) GOTO 170

C-- Top angle, W+ and W- for two jet systems. also quark-antiquark pairs

      DO 100 JS=1,2
         SA(JS)=PC(JS,1)/SQRT((PC(JS,4)-PC(JS,3))**2+PC(JS,1)**2)
         CA(JS)=SQRT(1.-SA(JS)**2)
         W(JS,1)=(PC(JS,4)+PC(JS,3)+PC(3,4))*CA(JS)-PC(JS,1)*SA(JS)
         W(JS,2)=(PC(JS,4)-PC(JS,3))*CA(JS)+PC(JS,1)*SA(JS)
         IFLQ(JS)=ISIGN(1+INT(RANP(ISEED)/PUD),IFL*ISIGN(1,3-2*JS))
CPA      IFLQ(JS)=ISIGN(1+INT(RANP(ISEED)/PUD),IFL*(-1)**(JS+1))
100   CONTINUE

C-- Form leading (gluon) meson. generate PT1, PT2, Z1+ and Z2+

      K(LASTN+1,1)=6*MAX0(IFLQ(1),IFLQ(2))-MIN0(IFLQ(1),IFLQ(2))-6
      K(LASTN+1,2)=KPART(K(LASTN+1,1),INT(PS1+RANP(ISEED)))
      P(LASTN+1,5)=GETMAS(K(LASTN+1,2))

  110 DO 120 JS=1,2
         CALL PTDIST(PX(JS),PY(JS),SIGMA)
  120    Z(JS,1)=ZDIST(IFLQ(JS),0.,1.)

C-- Choose Z1- and Z2- along hyperbola

      HA=(Z(1,1)*W(1,1)+Z(2,1)*W(2,1)*CA(1)/CA(2)+2.*PX(2)*CA(1)*
     +(SA(2)/CA(2)-SA(1)/CA(1)))*W(1,2)
      HB=(Z(2,1)*W(2,1)+Z(1,1)*W(1,1)*CA(2)/CA(1)+2.*PX(1)*CA(2)*
     +(SA(1)/CA(1)-SA(2)/CA(2)))*W(2,2)
      HC=CA(1)*CA(2)*(SA(1)/CA(1)-SA(2)/CA(2))**2*W(1,2)*W(2,2)
      HD=P(LASTN+1,5)**2+(PX(1)+PX(2))**2+(PY(1)+PY(2))**2
      IF(HA.LE.HD.OR.HB.LE.HD) GOTO 110
      HE=(HA*HB+HC*HD)**2

 130  Z(1,2)=RANP(ISEED)*HD/HA
      Z(2,2)=(HD-HA*Z(1,2))/(HB+HC*Z(1,2))
      IF(1.+HE/(HB+HC*Z(1,2))**4 .LT. (1.+HE/HB**4)*RANP(ISEED)**2)
     *     GOTO130

C-- Weighting in gamma for IFR=2. reject if remaining systems too small

      IF(IFR.NE.2) GOTO 141
      DO 140 JS=1,2
         QMTS(JS)=(QMAS(IABS(IFLQ(JS)))-QMAS(7))**2+PX(JS)**2+PY(JS)**2
  140    GAMM(JS)=(1.-Z(JS,1))*Z(JS,2)*W(JS,1)*W(JS,2)

      IF(GAMM(1)/(QMTS(1)+GAMM(1))*GAMM(2)/(QMTS(2)+GAMM(2)).LT.
     +RANP(ISEED)) GOTO 110

  141 CONTINUE
      DO 150 JS=1,2
  150 IF((1.-Z(JS,1))*(1.-Z(JS,2))*W(JS,1)*W(JS,2)-PX(JS)**2-PY(JS)**2.
     +LT.(QMAS(IABS(IFL))+QMAS(IABS(IFLQ(JS)))+PAR(9))**2) GOTO 110

C-- four-momentum for leading (gluon) meson

      P(LASTN+1,1)=PX(1)+Z(1,2)*W(1,2)*SA(1)+PX(2)+Z(2,2)*W(2,2)*SA(2)
      P(LASTN+1,2)=PY(1)+PY(2)
      P(LASTN+1,4)=(0.5*Z(1,1)*W(1,1)+0.5*Z(1,2)*W(1,2)+PX(1)*SA(1))
     +/CA(1)+(0.5*Z(2,1)*W(2,1)+0.5*Z(2,2)*W(2,2)+PX(2)*SA(2))/CA(2)
      P(LASTN+1,3)=P(LASTN+1,4)-Z(1,2)*W(1,2)*CA(1)-Z(2,2)*W(2,2)*CA(2)

C      N=1
C-- Start where we left off
      N=LASTN+1

C-- Call QQJET for treatment of remaining systems
      IST=IST+1
      DO 160 JS=1,2
         K(250,2)=N
         K(249,1)=-IFLQ(JS)
         P(249,1)=-PX(JS)
         P(249,2)=-PY(JS)
         P(249,3)=(1.-Z(JS,1))*W(JS,1)
         P(249,4)=(1.-Z(JS,1))*W(JS,1)
         P(249,5)=GAMM(JS)
         K(250,1)=IFL*ISIGN(1,3-2*JS)
CPA      K(250,1)=IFL*(-1)**(JS+1)
         P(250,1)=0.
         P(250,2)=0.
         P(250,3)=(1.-Z(JS,2))*W(JS,2)
         P(250,4)=W(JS,2)
         P(250,5)=0.
         CALL QQJET(0,0.)
#if defined(NONCLEO_DOUBLE)
         CALL ROTBST(0.D0,0.D0,SA(JS),0.D0,0.D0)
  160    CALL ROTBST(-ASIN(SA(JS)),0.D0,0.D0,0.D0,0.D0)
#else
         CALL ROTBST(0.,0.,SA(JS),0.,0.)
  160    CALL ROTBST(-ASIN(SA(JS)),0.,0.,0.,0.)
#endif

      IST=IST-1

C-- Rotate so fastest quark is along Z axis, gluon PX<0

  170 THEQ=ACOS(PC(1,3)/SQRT(PC(1,1)**2+PC(1,3)**2))
#if defined(NONCLEO_DOUBLE)
      CALL ROTBST(-THEQ,0.D0,0.D0,0.D0,0.D0)
#else
      CALL ROTBST(-THEQ,0.,0.,0.,0.)
#endif
C     IF(IST.EQ.0) CALL DECAYS

      RETURN
      END
