*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:02  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 21/01/93  15.42.12  by  Alan Weinstein
*-- Author :
      SUBROUTINE KORAL(E1,E2)
C     ***********************
C=======================================================================
C==================COMPUT. PHYS. COMMUN. PART ==========================
C=======================================================================
C THIS IS PART OF KORALB ALMOST IDENTICAL TO THAT PUBLISHED
C IN COMPUTER PHYSICS COMMUNICATIONS 36, (1985) 191,
C BY S. JADACH AND Z. WAS
C CORRECTIONS WITH RESPECT TO CPC VERSION MARKED WITH C;; (SJ)
C CORRECTIONS WITH RESPECT TO CPC VERSION MARKED WITH *$  (ZW)
C     ****************************************************************
C     *  THIS IS CENTRAL MENAGER    ROUTINE FOR TAUPAIR PRODUCTION   *
C     *  PROCESS IT CALLS OTHER ROUTINES CALCULATES THE SPIN WEIGHT  *
C     *  WHICH IS NEXT USED TO DECIDE WHETHER EVENT IS ACCEPTED OR   *
C     *  REJECTED. THIS WEIGHING AND REJECTING PROCEDURE INTRODUCES  *
C     *  CORRELATION IN THE DECAYS OF TWO TAUS AND OTHER SPIN        *
C     *  EFFECTS. E1 AND E2 ARE POLARISATION VECTORS OF E+ AND E-    *
C     ****************************************************************
C
      IMPLICIT REAL*8(A-H,O-Z)
      COMMON / UTIL1 / XK,C1,S1,C2,S2,CF,SF,CG,SG,V
      COMMON / CONTRL/ SWT(6),ISPIN
      DIMENSION E1(3),E2(3),SA(4),SB(4),H1(4),H2(4)
      COMPLEX*16 T1(4,4),T2(4,4),S(4,4),E(4,4)
      COMPLEX*16 ZERO,ROT,TOT
      REAL*4 RRR
      LOGICAL LSOF,LHAR
      ZERO=DCMPLX(0.D0,0.D0)
C-----IF ELECTRONS ARE UNPOLARIZED WE TAKE EASIER PATH
      SUM=0.
      DO 30 I=1,3
CAJWMOD: zero H1 and H2
        H1(I) = 0.D0
        H2(I) = 0.D0
CAJWMOD: end mod
   30 SUM=SUM+E1(I)**2+E2(I)**2
      IF(SUM.LT.0.0001) GO TO 200
C-----
C-----POLARIZED ELECTRONS
   50 CALL EVENTB
      CALL AMPLIT(T1,T2)
      KTO=1
      CALL DEKAY(KTO,H1)
      KTO=2
      CALL DEKAY(KTO,H2)
      H1(4)=1.
      H2(4)=1.
      CALL SPIN(E,H1,H2)
C-----ROTATION OF THE INITIAL POLARIZATION TO THE DYNAMIC COORDINATES
      SA(1)= CG*E1(1)+SG*E1(2)
      SA(2)=-SG*E1(1)+CG*E1(2)
      SA(3)=E1(3)
      SA(4)=1.
      SB(1)= CG*E2(1)+SG*E2(2)
      SB(2)=-SG*E2(1)+CG*E2(2)
      SB(3)=E2(3)
      SB(4)=1.
      CALL SPIN(S,SA,SB)
C---- CALCULATION OF THE SPIN WEIGHT FOR POLARIZED ELECTRONS
      LSOF= XK.EQ.0.
      LHAR= .NOT.LSOF
      ROT=ZERO
      TOT=ZERO
      DO 100 I=1,4
      DO 100 J=1,4
      IF(LSOF) TOT=TOT+DCONJG(T1(I,J))*T2(I,J)+DCONJG(T2(I,J))*T1(I,J)
      IF(LHAR) TOT=TOT+DCONJG(T1(I,J))*T1(I,J)+DCONJG(T2(I,J))*T2(I,J)
      DO 100 K=1,4
      DO 100 L=1,4
      IF(LSOF) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T2(L,J)+DCONJG(T2(K,I))*T1(L,J))*E(J,I)
      IF(LHAR) ROT=ROT+
     +S(K,L)*(DCONJG(T1(K,I))*T1(L,J)+DCONJG(T2(K,I))*T2(L,J))*E(J,I)
  100 CONTINUE
      WT=DREAL(ROT/TOT)
      SWT(4)=SWT(4)+1.
      SWT(5)=SWT(5)+WT
      SWT(6)=SWT(6)+WT*WT
      XLSP=8.
      CALL RANMAR(RRR,1)
      R=XLSP*RRR
      IF(R.GT.WT.AND.ISPIN.EQ.1) GOTO 50
      GOTO 400
C-----
C-----UNPOLARIZED ELECTRONS
  200 CONTINUE
      CALL EVENTB
      CALL AMPLIT(T1,T2)
  250 CONTINUE
      KTO=1
      CALL DEKAY(KTO,H1)
      KTO=2
      CALL DEKAY(KTO,H2)
      H1(4)=1.
      H2(4)=1.
      CALL SPIN(E,H1,H2)
C-----CALCULATE SPIN WEIGHT FOR UNPOLARIZED ELECTRONS
      LSOF= XK.EQ.0.
      LHAR= .NOT.LSOF
      ROT=ZERO
      TOT=ZERO
      DO 300 I=1,4
      DO 300 J=1,4
      IF(LSOF) TOT=TOT+DCONJG(T1(I,J))*T2(I,J)+DCONJG(T2(I,J))*T1(I,J)
      IF(LHAR) TOT=TOT+DCONJG(T1(I,J))*T1(I,J)+DCONJG(T2(I,J))*T2(I,J)
      DO 300 K=1,4
      IF(LSOF) ROT=ROT+
     +(DCONJG(T1(K,I))*T2(K,J)+DCONJG(T2(K,I))*T1(K,J))*E(J,I)
      IF(LHAR) ROT=ROT+
     +(DCONJG(T1(K,I))*T1(K,J)+DCONJG(T2(K,I))*T2(K,J))*E(J,I)
  300 CONTINUE
      WT=DREAL(ROT/TOT)
      SWT(4)=SWT(4)+1.
      SWT(5)=SWT(5)+WT
      SWT(6)=SWT(6)+WT*WT
      XLSP=2.
      CALL RANMAR(RRR,1)
      R=XLSP*RRR
      IF(R.GT.WT.AND.ISPIN.EQ.1) GOTO 250
  400 CONTINUE
C-----
      RETURN
      END
