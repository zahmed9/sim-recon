*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.3  1996/07/17 07:28:37  clib
* Protect against division by zero.
*
* Revision 1.2  1995/05/30  13:16:31  zfiles
* Handle B_C decays
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  23.14.34  by  Paul Avery
*CMZ :  1.03/70 19/10/93  13.09.14  by  Paul Avery
*CMZ :  1.03/45 30/04/92  11.54.36  by  Peter C Kim
*CMZ :  1.00/01 06/09/90  11.42.14  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.24  by  Paul Avery
*CMZ :          19/05/90  14.51.01  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE NONLEP(NP, NQ, KID, XM, KQ, KPAR, CMAS, T, IT, ND, PQ,
     *                  MTRX, IER)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Decays a particle nonleptonically.
C
C  The decay is specified initially as follows
C
C                P --> (real particles) + (q-qbar pairs)
C                         NP of these       NQ of these
C
C  The q-qbar pairs are combined into mesons and baryons (using a quark
C  or diquark popping mechanism) which are added to the end of the initial
C  particle list specified in KID. The decay then proceeds according to the
C  decay model specified by MATRX.
C
C  A total ND daughters are returned, where ND >= NP + NQ.
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C  NP        integer variable (read)
C            Initial number of daughter particles
C
C  NQ        integer variable (read)
C            Number of q-qbar pairs (length of KQ list)
C
C *KID       integer array (read/write)
C            Input:  Initial daughter particle IDs (length = NP)
C            Output: Final   daughter particle IDs (length = ND)
C
C *XM        real array (read/write)
C            Input:  Initial daughter masses (length = NP)
C            Output: Final   daughter masses (length = ND)
C
C  KQ        integer array (read)
C            List of q-qbar types (length = NQ)
C            K(1,i) = quark type (1 - 6) for q-qbar pair i
C            K(2,i) = anti-quark type (-1 - -6) for q-qbar pair i
C
C  KPAR      integer variable (read)
C            Parent particle ID
C
C  CMAS      real variable (read)
C            Mass of parent particle
C
C  T         real array (read)
C            4-vector of parent
C
C  IT        integer variable (read)
C            Class parent particle belongs to (needed to pick mult. parameters)
C              IT = 1   ordinary su(3) particle, charm = 0 baryons
C              IT = 2   D, F, charmed baryons
C              IT = 3   B
C              IT = 4   T
C              IT = 5  virtual photon or "general" qq state
C
C *ND        integer variable (write)
C            Number of daughters (final length of KID, XM, PQ)
C
C *PQ(4,*)   real array (write)
C            4-vectors of final daughters (length = ND)
C
C  MTRX      integer variable (read)
C            Model number for decay (specified in CHANNEL card)
C
C *IER       integer variable (write)
C            IER = 0 if all OK
C            IER > 0 if error
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"
#include "qqlib/seq/qqwjet.inc"
#include "qqlib/seq/qqluns.inc"
*

C     Calling arguments
      INTEGER NP, NQ, KPAR, IT, ND, MTRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), XM(30), PQ(4,30)
      DOUBLE PRECISION CMAS
#else
      REAL T(4), XM(30), PQ(4,30)
      REAL CMAS
#endif

C     Local variables
      INTEGER ICNT, NDMAX, NDMIN, IERR, IQ1, IQ2, NQT, KT
      INTEGER I, L, J, ISEED, IDUMMY, IDC
      INTEGER IDCSAV,ICHAN,JPAAR, NTEMP
      INTEGER IQCHRG(6), LIST(2)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CNDE, WID, CMEAN, COSTH, SINTH, COSPH, SINPH
      DOUBLE PRECISION WMAS, PPQ, TBR, TMAS, PWSQ, EWSQ
      DOUBLE PRECISION PW(4), PB(4), ROT(3,3), PQRK(4,3), WMSMIN(36)
      DOUBLE PRECISION XMT(2),PQT(4,2),XMATRX(7),TT(4)
      DOUBLE PRECISION PTR
#else
      REAL CNDE, WID, CMEAN, COSTH, SINTH, COSPH, SINPH
      REAL WMAS, PPQ, TBR, TMAS, PWSQ, EWSQ
      REAL PW(4), PB(4), ROT(3,3), PQRK(4,3), WMSMIN(36)
      REAL XMT(2),PQT(4,2),XMATRX(7),TT(4)
      REAL PTR
#endif

      COMMON/RANDM/ISEED

*
C     External declarations
      INTEGER MLTGEN, KPART
#if defined(NONCLEO_DOUBLE)
      REAL RANP
      DOUBLE PRECISION GETMAS
#else
      REAL RANP,GETMAS
#endif
      EXTERNAL MLTGEN, KPART,RANP,GETMAS
*
      DATA IQCHRG/2,-1,-1,2,-1,2/
      DATA WMSMIN/0.3,0.3,0.7,2.05,5.50,20.50,0.3,0.3,0.7,2.05,5.50,
     *              20.5,0.7,0.7,1.2,2.5,5.8,20.80,2.05,2.05,2.50,4.0,
     *              7.20,22.20,5.50,5.50,5.80,7.20,10.60,25.60,20.50,
     *              20.50,20.80,22.20,25.60,40.60/
C  ----------------------------------------------------------------------------
      IER = 0
      ICNT = 0

      IF(MTRX.EQ.0)GOTO 1000
      GOTO (1000,1500,2500,2500,3000),MTRX-5

C  MTRX = 0 .... decay b by phase space (old model)
1000  ND=NP
      IF(NQ.EQ.0)GOTO 1170
#if defined(NONCLEO_DOUBLE)
      CNDE=CMLT1(IT)*DLOG(CMAS/CMLT2(IT))
      WID=SQRT(DMAX1(CNDE*WIDTH(IT),.00001D0))
#else
      CNDE=CMLT1(IT)*ALOG(CMAS/CMLT2(IT))
      WID=SQRT(AMAX1(CNDE*WIDTH(IT),.00001))
#endif
      CMEAN=.5*(NP+NQ)+CNDE
      NDMAX=10
      IF(CMAS.GT.5)NDMAX=20
      NDMIN=MAX0(2,NP+NQ)
1230  ND=MLTGEN(CMEAN,WID,NDMIN,NDMAX)

C  Pair up qq pairs
1130  CALL DECQRK(ND,NP,NQ,CMAS,KID,XM,KQ,1,IERR)
      IF(IERR.EQ.1)GOTO 1230

C  Do phase space decay
1170  IF(LPHASE.AND.MTRX.EQ.0)CALL PHSP(T,CMAS,0,ND,XM,PQ)
      IF(LPHASE.AND.MTRX.EQ.6)CALL PHSP(T,CMAS,2,ND,XM,PQ)
      RETURN

C     MTRX = 7
1500  RETURN

C     MTRX = 8 or 9
2500  CONTINUE

C  Get quarks from virtual W decay
      IQ1 = KQ(1,1)
      IQ2 = -KQ(2,1)

C     See if ud,us,cs,cu,etc.

      NQT = 6*IQ1 + IQ2 - 6

C   Get the heavy quark + spectator and form a meson.
C   however if user has chosen to decay X >>> Y + W* where
C   Y is a real particle, bypass this step.

      IF(NP.NE.1 .OR. NQ.NE.1)THEN
        KT = 6*KQ(1,2) - KQ(2,2) - 6
        KID(1) = KPART(KT,IDUMMY)
        XM(1) = AMASS(KID(1))
      ENDIF

      IF(MTRX.EQ.8) THEN
        IF(KID(1).EQ.27.OR.KID(1).EQ.67)  KID(1) = 291
        IF(KID(1).EQ.28.OR.KID(1).EQ.68)  KID(1) = 292
        IF(KID(1).EQ.29.OR.KID(1).EQ.69)  KID(1) = 293
        IF(KID(1).EQ.30.OR.KID(1).EQ.70)  KID(1) = 294
        IF(KID(1).EQ.31.OR.KID(1).EQ.71)  KID(1) = 495
        IF(KID(1).EQ.32.OR.KID(1).EQ.72)  KID(1) = 496
        XM(1) = GETMAS(KID(1))
      ENDIF

C-- Now do V-A decay of the b and form W 4-vector

      XM(2) = BQMAS(IQ1)
      XM(3) = BQMAS(IQ2)

2510  CALL PHSP(T,CMAS,1,3,XM,PQRK)


C-- Get W 4-vector and mass

      DO 2540 L=1,4
        PW(L) = PQRK(L,2) + PQRK(L,3)
2540  CONTINUE

      PWSQ = PW(1)**2 + PW(2)**2 + PW(3)**2
      EWSQ = PW(4)*PW(4)
      IF(PWSQ.GE.EWSQ) GOTO 2510
      WMAS = SQRT(EWSQ - PWSQ)

      IF(WMAS .LT. WMSMIN(NQT))THEN
        ICNT=ICNT+1
        IF(ICNT.GT.30)THEN
          IER=1
          RETURN
        ENDIF
        GOTO 2510
      ENDIF


      IF(MTRX.EQ.9) THEN
        NTEMP = 1
        DO 2550 I=1,4
          PQ(I,1) = PQRK(I,1)
 2550   CONTINUE
      ENDIF

C-- Decay pseudo 2-body CU2,CD2's, and save their daughters as
C   direct decay product of the B.

      IF(MTRX.EQ.8) THEN


        TMAS  = XM(1)
        DO 2560 I=1,4
          TT(I) = PQRK(I,1)
 2560   CONTINUE
        TBR = RANP(0)

        IDC = IPLIST(1,KID(1)) - 1
        IDCSAV = IDC
 2570   IDC = IDC + 1
        IF(TBR.GT.BRLIST(IDC)) GOTO 2570
        ICHAN = IDC - IDCSAV

        JPAAR = MLLIST(2,IDC)
        LIST(1) = IDLIST(JPAAR)
        LIST(2) = IDLIST(JPAAR+1)

        XMT(1) = GETMAS(LIST(1))
        XMT(2) = GETMAS(LIST(2))

#if defined(NONCLEO_DOUBLE)
        DO I=1,7
          XMATRX(I) = 0.D0
        ENDDO
#else
        CALL VZERO(XMATRX, 7)
#endif
        CALL QQGEN2(TT, TMAS, XMATRX, XMT, PQT)

        NTEMP = 2
        KID(1) = LIST(1)
        KID(2) = LIST(2)
        XM(1)  = XMT(1)
        XM(2)  = XMT(2)
        DO 2580 I=1,4
          PQ(I,1) = PQT(I,1)
          PQ(I,2) = PQT(I,2)
 2580   CONTINUE

      ENDIF

C  Fragment quarks in w center of mass

      ND = NTEMP
      CALL WJET(WMAS,ND,KQ,PQ,KID,XM,SIGMA)

C  Fragmentation is along z direction in w cm system
C  direction to rotate it is along 1st quark's direction
#if defined(NONCLEO_DOUBLE)
      CALL DBOOSB(PW,1,PQRK(1,2),PQRK(1,2))
#else
      CALL RBOOSB(PW,1,PQRK(1,2),PQRK(1,2))
#endif
      PPQ = SQRT(PQRK(1,2)**2 + PQRK(2,2)**2 + PQRK(3,2)**2)
      COSTH = PQRK(3,2) / PPQ
      SINTH = SQRT(1. - COSTH**2)

C protect against division by zero (7/96)
C
      IF(SINTH.NE.0.0) THEN
        COSPH = PQRK(1,2) / (PPQ*SINTH)
        SINPH = PQRK(2,2) / (PPQ*SINTH)
      ELSE
        COSPH = 0.6
        SINPH = 0.8
      ENDIF

      ROT(1,1) = COSTH*COSPH
      ROT(1,2) = -SINPH
      ROT(1,3) = SINTH*COSPH
      ROT(2,1) = COSTH*SINPH
      ROT(2,2) = COSPH
      ROT(2,3) = SINTH*SINPH
      ROT(3,1) = -SINTH
      ROT(3,2) = 0
      ROT(3,3) = COSTH

C  Rotate to correct angle
      DO 2700 J=NTEMP+1,ND
        DO 2600 I=1,3
          PB(I) = PQ(I,J)
2600    CONTINUE
        DO 2640 I=1,3
          PQ(I,J) = ROT(I,1)*PB(1)+ROT(I,2)*PB(2)+ROT(I,3)*PB(3)
2640    CONTINUE
2700  CONTINUE

C  Now boost into b rest frame

#if defined(NONCLEO_DOUBLE)
      CALL DBOOSF(PW,ND-NTEMP,PQ(1,NTEMP+1),PQ(1,NTEMP+1))
#else
      CALL RBOOSF(PW,ND-NTEMP,PQ(1,NTEMP+1),PQ(1,NTEMP+1))
#endif
      RETURN

C     MTRX = 10
3000  RETURN
      END
