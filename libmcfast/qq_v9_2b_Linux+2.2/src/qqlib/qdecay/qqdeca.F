*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.6  1996/03/27 03:56:42  zfiles
* A nug fix from Peter
*
* Revision 1.5  1996/03/19 15:56:58  zfiles
* Omega/phi --> 3 pi, check the helicity distribution
*               It can handle a+bCOS+cCOS**2 for now.
*                                               3/96  PCK
*
* Revision 1.4  1996/02/16 20:00:39  zfiles
* Call to omg3pi subtroutine disabled.
*
* Revision 1.3  1995/05/02  12:30:47  zfiles
* Bug fix in qqdeca.F.
*
* Revision 1.2  1994/11/15  02:11:31  lkg
* Fix code so that J/Psi's can radiate again.
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.17.11  by  Paul Avery
*CMZ :  1.03/71 02/12/93  14.35.42  by  Lynn Garren
*CMZ :  1.03/70 15/10/93  10.02.51  by  Paul Avery
*CMZ :  1.03/65 22/06/93  11.16.59  by  Alan Weinstein
*CMZ :  1.03/60 16/03/93  11.54.12  by  Peter C Kim
*CMZ :  1.03/59 28/02/93  18.13.33  by  Peter C Kim
*CMZ :  1.03/58 22/02/93  19.52.58  by  Peter C Kim
*CMZ :  1.03/57 15/02/93  17.18.55  by  Peter C Kim
*CMZ :  1.03/51 05/11/92  16.55.26  by  Unknown
*CMZ :  1.03/49 25/09/92  17.27.03  by  Peter C Kim
*CMZ :  1.03/45 08/05/92  14.00.13  by  Peter C Kim
*CMZ :  1.03/39 20/01/92  11.38.41  by  Peter C Kim
*CMZ :  1.03/33 05/12/91  12.04.40  by  Peter C Kim
*CMZ :  1.03/26 08/10/91  11.38.09  by  Peter C Kim
*CMZ :  1.03/16 23/07/91  02.54.10  by  Peter C Kim
*CMZ :  1.02/00 07/03/91  17.29.05  by  Peter C Kim
*CMZ :  1.01/02 16/11/90  17.46.56  by  Paul Avery
*CMZ :  1.01/00 03/11/90  16.26.58  by  Paul Avery
*CMZ :          12/10/90  08.54.49  by  Paul Avery
* 16/10/96 Lynn Garren:  Add double precision conditionals.
* 11/11/96 Lynn Garren:  Add check for attempted decays of massless particles.
      SUBROUTINE QQDECA(IPD,LAST,ICHAN)
C
C    NHEL/IHEL definition corrected           PCK   7/03/91
C    ETPDEC for eta' --> gamma rho added      PCK  23/07/91
C    Subroutine name can be other than DECAY  for non-CLEO users
C                                             PCK  14/01/92
C    PSILLG for rad. dilepton decays of J/Psi PCK  15/02/93
C    Add MATRIX=12, Dalitz decays of pi0,eta  AJW  22/06/93
C.............................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"
#include "qqlib/seq/qqluns.inc"
*
C     Calling arguments
      INTEGER IPD, LAST, ICHAN

C     Local variables
      INTEGER I, L, J, IDC, IDCSAV, IPOL, NPOL, IHEL, NHEL, KPRNT, IH
      INTEGER NDAU, JPPAR, IERR, IT, NP, ND, NQ, IER, MATRX, NMATRX
      INTEGER KID(30), KQ(2,5), INDX, IP, LIST(30), NHIDDN, FOUND
      INTEGER NDTRY, NDALL, PUT, NDTMP, ND1, ICHAN2, IHEL2
#if defined(NONCLEO_DOUBLE)
      REAL TBR, HEL, R, HEL2
      DOUBLE PRECISION CMAS, XMATRX(7), TMASSQ
      DOUBLE PRECISION PQ(4,30), XM(30), T(4), TPRNT(4)
      DOUBLE PRECISION PQB(4,30),TPRNTB(4)
      DOUBLE PRECISION PNOR1,PNOR2,PNOR3,COSXX,DIST
#else
      REAL TBR, CMAS, XMATRX(7), HEL, R, HEL2
      REAL PQ(4,30), XM(30), T(4), TPRNT(4)
      REAL PQB(4,30),TPRNTB(4)
      REAL PNOR1,PNOR2,PNOR3,COSXX,DIST
#endif
*
C     External declarations

#if defined(NONCLEO_DOUBLE)
      REAL     RANP
      DOUBLE PRECISION GETMAS
#else
      REAL     RANP, GETMAS
#endif
      EXTERNAL RANP, GETMAS
C  ---------------------------------------------------------------------------

C     Choose new decay mode again in case masses violate energy conservation
      NDTRY = 0
50    NDTRY = NDTRY + 1

C     Get info about the decay
      CALL QQCHNL(K(IPD,2), IPD, ICHAN, NDAU, LIST, MATRX, NMATRX,
     *            XMATRX, IDC, IHEL, HEL)

C    Parent
      KPRNT = -K(IPD,1)

C   CMAS = mass of parent
      CMAS = P(IPD,5)

C   MATRX < 0 .... quark or gluon jet decay
      IF(MATRX .LT. 0) THEN
        CALL JETDEC(IPD,CMAS,LAST,MATRX,NDAU,IERR)
        IF(IERR .NE. 0)GOTO 50
        RETURN
      ENDIF

C     Get parameters for MATRX >= 0
      CALL GETPAR(IPD,IT,KID,XM,CMAS,NDAU,LIST,NP,NQ,KQ,ND,IERR)

C     if masses too large, redo decay channel
      IF(IERR.NE. 0) THEN
        IF(NDTRY.LT.50000) THEN
          GOTO 50
        ELSE
          WRITE(LTTOQQ,8889)
          WRITE(LTTOQQ,8890) K(IPD,2)
          IF(K(IPD,2).EQ.0) WRITE(LTTOQQ,8891)
          STOP
        ENDIF
      ENDIF

 8889   FORMAT('  Caught in an Infinite Loop in QQDECA, ')
 8890   FORMAT('    while decaying particle # ', I4)
 8891   FORMAT(' ****  CHECK the ECM/ENRGMN/ENRGMX vs M_B ****')

C   4 momentum to boost to
      DO 152 I=1,4
        T(I) = P(IPD,I)
152   CONTINUE

C   fill 4 momentum for grandparent
      IF(KPRNT .GT. 0) THEN
        DO 170 L=1,4
          TPRNT(L) = P(KPRNT,L)
170     CONTINUE
      ENDIF

#if defined(NONCLEO_DOUBLE)
C    check for decay of massless particle..........
      TMASSQ = T(4)**2-T(2)**2-T(3)**2-T(1)**2
      IF(TMASSQ .LE. 0.D0) THEN
        IF(NDTRY.LT.5000) THEN
          IF(NDTRY.EQ.1) WRITE(LTTOQQ,8892) K(IPD,2),CMAS,TMASSQ
          GOTO 50
        ELSE
          WRITE(LTTOQQ,8889)
          WRITE(LTTOQQ,8890) K(IPD,2)
          WRITE(LTTOQQ,8892) K(IPD,2),CMAS,TMASSQ
          WRITE(LTTOQQ,8893) IPD,T(1),T(2),T(3),T(4)
          DO I=1,IPD
            WRITE(LTTOQQ,8894) IPRNTV(I),ITYPEV(I,1),ITYPEV(I,2),
     1                 P4QQ(1,I),P4QQ(2,I),P4QQ(3,I),P4QQ(4,I)
          ENDDO
          STOP
        ENDIF
      ENDIF
 8892   FORMAT(' Particle ',I4,' has official mass ',F12.6,
     1         ' and real mass squared ',F12.6)
 8893   FORMAT(' particle number ',I3,' momentum ',4F12.6)
 8894   FORMAT(3I10,4F12.6)
#endif

C     Come back here if generated final state is in our exclusive list
3000  CONTINUE

C   2 body final state
      IF(NDAU.EQ.2 .AND. NQ.EQ.0 .AND. MATRX.LT.20 ) THEN
        CALL QQ2BOD(KPRNT, TPRNT, T, CMAS, XMATRX, XM, PQ)

C   MATRX = 0 .... nonleptonic decays
      ELSE IF(MATRX .EQ. 0) THEN
        CALL NONLEP(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 1-5 .... semileptonic decays
      ELSE IF(MATRX.EQ.1 .OR. MATRX.EQ.2) THEN
        CALL SEMI(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

      ELSE IF(MATRX .EQ. 3) THEN
        CALL SEMI2(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

      ELSE IF(MATRX .EQ. 4) THEN
        CALL BRYLEP(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

      ELSE IF(MATRX .EQ. 5) THEN
        CALL SEMI(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 6-10 .... nonleptonic decays
      ELSE IF(MATRX.GE.6 .AND. MATRX.LE.10) THEN
180     CONTINUE
        CALL NONLEP(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C          Omega/phi --> 3 pi, check the helicity distribution
C                        It can handle a+bCOS+cCOS**2 for now.
C                                                        3/96  PCK
        IF(MATRX.EQ.6.AND.KPRNT.GT.0.AND. 
     *  (XMATRX(1).NE.0..OR.XMATRX(2).NE.0..OR.XMATRX(3).NE.0.)) THEN
#if defined(NONCLEO_DOUBLE)
          CALL DBOOSB(T,2,PQ,PQB)
          CALL DBOOSB(T,1,TPRNT,TPRNTB) 
#else
          CALL RBOOSB(T,2,PQ,PQB)
          CALL RBOOSB(T,1,TPRNT,TPRNTB) 
#endif
          PNOR1 = PQB(2,1)*PQB(3,2) - PQB(3,1)*PQB(2,2)
          PNOR2 = PQB(3,1)*PQB(1,2) - PQB(1,1)*PQB(3,2)
          PNOR3 = PQB(1,1)*PQB(2,2) - PQB(2,1)*PQB(1,2)
          COSXX = (PNOR1*TPRNTB(1)+PNOR2*TPRNTB(2)+PNOR3*TPRNTB(3))
     *            /SQRT(PNOR1**2+PNOR2**2+PNOR3**2)
     *            /SQRT(TPRNTB(1)**2+TPRNTB(2)**2+TPRNTB(3)**2)
          DIST = XMATRX(1) + XMATRX(2)*COSXX + XMATRX(3)*COSXX**2
          IF(RANP(0).GT.DIST) GOTO 180
        ENDIF
      ELSE IF(MATRX .EQ. 11) THEN
        CONTINUE

C   MATRX = 12 .... Dalitz decays of pi0, eta
      ELSE IF(MATRX .EQ. 12) THEN
        CALL DALDEC(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 13 .... exotic model 3 ... b -> q l l (+ spectator)
      ELSE IF(MATRX .EQ. 13) THEN
        CALL EXO3(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 14 .... exotic model 4 ... b -> qbar, qbar, l (+ spectator )
      ELSE IF(MATRX .EQ. 14) THEN
        CALL EXO4(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 15 .... non-exclusive hadronic tau decays
      ELSE IF(MATRX .EQ. 15) THEN
        CALL TAUHAD(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 17,18 .... eta decays to pi+ pi- pi0 and pi+ pi- gamma
      ELSE IF(MATRX.EQ.17 .OR. MATRX.EQ.18) THEN
        CALL ETADEC(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 19    .... omega --> pi+ pi- pi0
C   OMG3PI subroutine withdrawn. (was never used)
C   We have always used PHSP with matrix #6 for the 3-pion decay
C
CXX      ELSE IF(MATRX .EQ. 19) THEN
CXX      CALL OMG3PI(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 20    .... eta' --> gamma rho
      ELSE IF(MATRX .EQ. 20) THEN
        CALL ETPDEC(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 21 - 30   .... baryon decays
      ELSE IF(MATRX.GE.21 .AND. MATRX.LE.30) THEN
        CALL BRYNON(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 40 - 43   .... Rad. J/Psi decay to dileptons
      ELSE IF(MATRX.GE.40 .AND. MATRX.LE.43) THEN
        IF(MATRX.EQ.40) THEN
          IF(HEL.EQ. 0.0) MATRX = 43
          IF(HEL.EQ. 1.0) MATRX = 42
          IF(HEL.EQ.-1.0) MATRX = 42
        ENDIF

        CALL PSILLG(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)
        IF(IER.NE.0) THEN
            WRITE(LTTOQQ,8888)
 8888       FORMAT('  PSILLG called with Improper decay mode.')
            STOP
        ENDIF

C   MATRX = 51 - 53   .... ISGW model for semileptonic decays
      ELSE IF(MATRX.GE.51 .AND. MATRX.LE.53) THEN
        CALL SEMIL1(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)
        IF(IER.NE.0) THEN
            WRITE(LTTOQQ,8887)
 8887       FORMAT('  SEMIL1 called with Improper decay mode.')
            STOP
        ENDIF

C   MATRX = 61 - 63   .... Korner/Schuler model for semileptonic decays
      ELSE IF(MATRX.GE.61 .AND. MATRX.LE.63) THEN
        CALL SEMIL2(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 71 - 73   .... WSB model for semileptonic decays
      ELSE IF(MATRX.GE.71 .AND. MATRX.LE.73) THEN
        CALL SEMIL3(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX = 81 - 83   .... hadronic tau decays
      ELSE IF(MATRX.GE.81 .AND. MATRX.LE.85) THEN
        CALL TAUMAT(NP,NQ,KID,XM,KQ,K(IPD,2),
     *                                CMAS,T,IT,ND,PQ,MATRX,IER)

C   MATRX > 10000   .... User defined decay
      ELSE IF(MATRX .GT. 10000) THEN
        CALL USRDEC(NP,NQ,KID,XM,KQ,K(IPD,2),CMAS,T,IT,ND,PQ,MATRX,IER)

      ENDIF

C     If error, try again
      IF(IER .NE. 0) THEN
        IF(NDTRY.LT.10000) THEN
          GOTO 50
        ELSE
          WRITE(LTTOQQ,8889)
          WRITE(LTTOQQ,8890) K(IPD,2)
          STOP
        ENDIF
      ENDIF


C    See if there are any hidden particles
      NHIDDN = 0
      DO 4004 J=1,ND
        IF(HIDEQQ(KID(J))) NHIDDN = NHIDDN + 1
4004  CONTINUE

C-- If quarks are decayed, check whether the final state is already
C   defined in the exclusive decay list.
      IF(MATRX.EQ.8 .OR. MATRX.EQ.9 .OR. (MATRX.EQ.0.AND.NQ.NE.0)) THEN
        CALL QQCHEX(K(IPD,2), ND, KID, FOUND)
        IF(FOUND .NE. 0) GOTO 3000
      ENDIF

C     Set helicity values for daughters if specified
C     Use probability distribution stored in HELPRB, HELLST databases
C     Do not do this if there are hidden particles
      IF(MATRX.LT.40 .OR. MATRX.GT.43) THEN
        IF(NHIDDN.EQ.0 .AND. IHEL.GT.0) THEN
          IH = IHEL - 1
          R = RANP(0)
4210      IH = IH + 1
          IF(R .GT. HELPRB(IH)) GOTO 4210
          IP = IHLPRB(IH) - 1
          DO 4220 J=1,NDAU
            HELCQQ(LAST+J) = HELLST(IP+J)
4220      CONTINUE
        ENDIF

      ENDIF

C     If any particle in the daughter list is a hidden particle, decay
C     it now and place its daughters at the end of the daughter list of
C     the original parent.  We will strip out hidden particle below.
C
C                                             (modified by JDL 4/95)
      NDTMP = ND
      DO WHILE (NHIDDN.GT.0.AND.NDTMP.GT.0)
          IF(HIDEQQ(KID(NDTMP))) THEN
              ND1 = ND + 1
              CALL QQCHNL(KID(NDTMP), 0, ICHAN2, NDAU, KID(ND1), 
     *            MATRX, NMATRX, XMATRX, IDC, IHEL2, HEL2)
              DO 4250 J=1,NDAU
                  XM(ND+J) = GETMAS(KID(ND+J))
4250            CONTINUE
              CALL PHSP(PQ(1,NDTMP), XM(NDTMP), 0, NDAU, 
     *            XM(ND1), PQ(1,ND1))
              ND = ND + NDAU
              NHIDDN= NHIDDN-1
            ENDIF ! (HIDDQQ...
          NDTMP = NDTMP - 1
      ENDDO 


C     Fill up sjostrand arrays with unhidden particles

      NDALL = 0
      DO 4550 J=1,ND
        IF(HIDEQQ(KID(J)) ) GOTO 4550
        NDALL = NDALL + 1
        PUT = LAST + NDALL
        K(PUT,1) = -IPD
        K(PUT,2) = KID(J)
        DO 4545 L=1,4
          P(PUT,L) = PQ(L,J)
4545    CONTINUE
        P(PUT,5) = XM(J)
4550  CONTINUE

C   Special case of 1 particle decay
      IF(ND .EQ. 1) P(LAST+1,5) = CMAS
      LAST = LAST + NDALL

C. Call mixing/cp routine -pdr 10-29-90
      CALL MCMXCP(IPD, ND, IDC)

      RETURN
      END
