*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:37  eugenio
* Initial revision
*
* Revision 1.2  1995/08/24  16:51:24  zfiles
* Fix bugs in in event decay history for Upsilon decays,
* one is Jetset, the other in decadl.F
* Fix for boosting in case of asymetric beams.
*
* Revision 1.1.1.1  1994/10/08  02:21:34  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  17.18.52  by  Paul Avery
*CMZ :  1.03/76 15/08/94  23.45.07  by  Peter C Kim
*CMZ :  1.03/73 17/12/93  16.48.29  by  Peter C Kim
*CMZ :  1.03/71 27/11/93  23.38.43  by  Peter C Kim
*CMZ :  1.03/66 28/06/93  21.00.25  by  Peter C Kim
*CMZ :  1.03/56 14/12/92  13.32.35  by  Peter C Kim
*CMZ :  1.03/45 28/04/92  10.05.11  by  CLEO II Librarian
*CMZ :  1.03/15 22/07/91  21.24.39  by  Peter C Kim
*CMZ :  1.03/00 02/04/91  10.03.33  by  Peter C Kim
*CMZ :  1.02/00 12/03/91  15.17.48  by  Peter C Kim
*-- Author :    Peter C Kim   12/02/91
* 15/10/96 Lynn Garren: Add double precision conditionals.
*                       Notice that P4(4) is unused - remove it.
      SUBROUTINE DECADL
C.......................................................................
C.
C. DECADL - Modified version of DECADD for LUND generated events.
C.
C. COMMON    : LUJETS  --> JETS, MCCOMS

C. Calls     : DECAY, LQPMAT, NTONJS
C. Called    : QMLUND
C. Author    : Peter C Kim  12/02/91  12.19.32
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqbfld.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"
#include "qqlib/seq/jetscl.inc"
#include "qqlib/seq/lujetx.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/seq/ludat2.inc"
#include "geant/gcdes/ludat3.inc"
#include "qqlib/seq/ludat4.inc"
#include "qqlib/seq/ludatr.inc"

C- External declarations

      REAL     RANP
      INTEGER LQPMAT
      EXTERNAL RANP,LQPMAT

C-- Local variables

      INTEGER I, L, J, IPD, IPUT, IPUTSV, ICHAN
      INTEGER IOFSET, NDAU, IDAU, IT, ITYP, IV, IP, IC
#if defined(NONCLEO_DOUBLE)
      double precision PX, PY
      REAL R, FACT, A, SINPS, COSPS, DCOSPS, DELTAX
#else
      REAL R, FACT, A, SINPS, COSPS, DCOSPS, PX, PY, P4(4), DELTAX
#endif
      INTEGER LCOR(500)

      INTEGER ICHSAV
      COMMON /LUSAV/ ICHSAV(1000)

C-- Executable code starts here-----------------------------------------------

      CALL VZERO(LCOR,500)

C-- Loop over the particles in the LUND event list
C                (quarks,gluons, and strings are already removed.)

C-- /LUJETS/ --> /LUJETX/

      CALL NTONJS

C-- /LUJETX/ --> /JET/

      N = NJS
      DO 1 I=1,NJS
        K(I,1) = -KJS(I,3)
        K(I,2) = LQPMAT(KJS(I,2),1)
        P(I,1) = PJS(I,1)
        P(I,2) = PJS(I,2)
        P(I,3) = PJS(I,3)
        P(I,4) = PJS(I,4)
        P(I,5) = PJS(I,5)
        IPRNTV(I) = KJS(I,3)
 1    CONTINUE

C-- Fill MCCOMS and decay particles if necessary

      IPD  = 0
      IPUT = N
 2050 IPD  = IPD + 1
      IF(IPD.GT.IPUT .OR. IPUT.GE.MCTRK-3) GOTO 8000

      IPUTSV = IPUT
      ICHAN  = 0
      IOFSET = IPUT - IPD + 1
      NTRKQQ = NTRKQQ + 1

      DO 100 L=1,4
        P4QQ(L,NTRKQQ) = P(IPD,L)
 100  CONTINUE

      ITYP  =  K(IPD,2)
      ITYPEV(NTRKQQ,1) = ITYP
      IT = NTRKQQ

C-- If primary particle, add to primary vertex list
C                                        NVRTX = 1 (set in modevt.F)
      IF(IPRNTV(NTRKQQ).EQ.0) THEN
        NTRKOU(1) = NTRKOU(1) + 1
        IVPROD(NTRKQQ) = 1
        IF(ITRKOU(1) .EQ. 0) ITRKOU(1) = NTRKQQ
      ENDIF

C-- Stable particle

      IF(IPLIST(1,ITYP) .EQ. 0) THEN
        NDAUTV(NTRKQQ) = 0
        IDAUTV(NTRKQQ) = 0
        IDECSV(NTRKQQ) = 0
        IVDECA(NTRKQQ) = 0
      ELSE

C-- Unstable, but already decayed in LUND

        IF(IPD.LE.NJS.AND.KJS(IPD,1).EQ.11) THEN

          LCOR(NTRKQQ) = -1
CC          ICHAN = ICHSAV(IPD)
          NVRTX = NVRTX + 1

C   LUND events are generated at (0,0,0)
C                                                Unit length = Meter

          XVTX(NVRTX,1) = XVTX(1,1) + VJS(KJS(IPD,4),1) * 0.001
          XVTX(NVRTX,2) = XVTX(1,2) + VJS(KJS(IPD,4),2) * 0.001
          XVTX(NVRTX,3) = XVTX(1,3) + VJS(KJS(IPD,4),3) * 0.001
          RVTX(NVRTX) = SQRT(XVTX(NVRTX,1)**2 + XVTX(NVRTX,2)**2)
          TVTX(NVRTX) = SQRT(XVTX(NVRTX,3)**2 + RVTX(NVRTX)**2)

          NDAU = KJS(IPD,5) - KJS(IPD,4) + 1
          IVDECA(NTRKQQ) = NVRTX
          NDAUTV(NTRKQQ) = NDAU
          IDAUTV(NTRKQQ) = KJS(IPD,4)
          IDECSV(NTRKQQ) = ICHAN
          IVKODE(NVRTX) = 1
          NTRKOU(NVRTX) = NDAU
          ITRKOU(NVRTX) = KJS(IPD,4)
          ITRKIN(NVRTX) = NTRKQQ

          CALL VFILL(IVPROD(IDAUTV(NTRKQQ)), NDAU, NVRTX)
          CALL VFILL(IPRNTV(IDAUTV(NTRKQQ)), NDAU, NTRKQQ)

        ELSE

C--               Unstable, and we will decay it here.

C-- Long-lived particles are not decayed in QQ.

          IF(.NOT.LONGLF.AND.CTAU(ITYP).GT.0.01) THEN
            NDAUTV(NTRKQQ) = 0
            IDAUTV(NTRKQQ) = 0
            IDECSV(NTRKQQ) = 0
            IVDECA(NTRKQQ) = 0
            GOTO 2100
          ENDIF

C
C                                             Generate lifetime/mass
          IF(CTAU(ITYP) .EQ. 0.) THEN
            FACT = 0.
          ELSE IF(CTAU(ITYP) .GT. 0.) THEN
            R = RANP(0)
            FACT = -CTAU(ITYP)/AMASS(ITYP) * ALOG(MAX(R,1.E-4))
          ENDIF

C-----------------------------------------------------------------
C     The basic helix equations are (s = arc length)
C    x = x0 + (u0/rho)sin(rhop*s) - (v0/rho)*[1-cos(rhop*s)]
C    y = y0 + (v0/rho)sin(rhop*s) + (u0/rho)*[1-cos(rhop*s)]
C    z = z0 + Pz/P * s
C
C    Define a = -0.2998 * Q * B, where Q, B are charge, B field
C      s      = FACT * P    (FACT defined above = C*T / MASS)
C      rho    = a / Pt
C      rhop   = a / P
C      rhop*s = a * s / P = a * FACT
C      u0/rho = Px / a
C      v0/rho = Py / a
C
C    B field non-zero
C    x   = x0 + (Px/a)*sin(a*FACT) - (Py/a)*[1-cos(a*FACT)]
C    y   = y0 + (Py/a)*sin(a*FACT) + (Px/a)*[1-cos(a*FACT)]
C    z   = z0 + Pz * FACT
C    Px' = Px*cos(a*FACT) - Py*sin(a*FACT)
C    Py' = Py*cos(a*FACT) + Px*sin(a*FACT)
C
C    B field  = 0
C    x = x0 + Px * FACT
C    y = y0 + Py * FACT
C    z = z0 + Pz * FACT
C-----------------------------------------------------------------

C-- Make new decay vertex. IV is the production vertex of this particle

          NVRTX = NVRTX + 1

          A = -0.02998 * CHARGE(ITYP) * BFLDQQ
          IV = IVPROD(NTRKQQ)
          IF(A .EQ. 0.) THEN
            XVTX(NVRTX,1) = XVTX(IV,1) + FACT * P4QQ(1,IT)
            XVTX(NVRTX,2) = XVTX(IV,2) + FACT * P4QQ(2,IT)
            XVTX(NVRTX,3) = XVTX(IV,3) + FACT * P4QQ(3,IT)
          ELSE
            SINPS = SIN(A * FACT)
            COSPS = COS(A * FACT)
            DCOSPS = 1. - COSPS
            XVTX(NVRTX,1) = XVTX(IV,1) + P4QQ(1,IT)/A * SINPS -
     *                      P4QQ(2,IT)/A * DCOSPS
            XVTX(NVRTX,2) = XVTX(IV,2) + P4QQ(2,IT)/A * SINPS +
     *                      P4QQ(1,IT)/A * DCOSPS
            XVTX(NVRTX,3) = XVTX(IV,3) + FACT * P4QQ(3,IT)

C-- Swim the momentum vector
            PX = P4QQ(1,IT)*COSPS - P4QQ(2,IT)*SINPS
            PY = P4QQ(2,IT)*COSPS + P4QQ(1,IT)*SINPS
            P(IPD,1) = PX
            P(IPD,2) = PY
          ENDIF

          TVTX(NVRTX) = TVTX(IV) + FACT * P4QQ(4,IT) / 2.998E-4
          RVTX(NVRTX) = SQRT(XVTX(NVRTX,1)**2 + XVTX(NVRTX,2)**2)

          CALL QQDECA(IPD, IPUT, ICHAN)
          NDAU = IPUT - IPUTSV
          IVDECA(NTRKQQ) = NVRTX
          NDAUTV(NTRKQQ) = NDAU
          IDAUTV(NTRKQQ) = NTRKQQ + IOFSET
          IDECSV(NTRKQQ) = ICHAN
          IVKODE(NVRTX) = 1
          NTRKOU(NVRTX) = NDAU
          ITRKOU(NVRTX) = NTRKQQ + IOFSET
          ITRKIN(NVRTX) = NTRKQQ

C     Set the production vertex and the parent of all the daughters
          CALL VFILL(IVPROD(IDAUTV(NTRKQQ)), NDAU, NVRTX)
          CALL VFILL(IPRNTV(IDAUTV(NTRKQQ)), NDAU, NTRKQQ)

        ENDIF
      ENDIF

 2100 GOTO 2050

C     End of loop
8000  N = IPUT

C-- store stable particle information
      NSTBMC = 0
      NCHGMC = 0
      CALL VZERO (ISTBMC, MCTRK)
      DO 150 IP=1,NTRKQQ
        ITYP = ITYPEV(IP,1)
        ITYPEV(IP,2) = IDMC(ITYP)
        IF(LCOR(IP).EQ.-1) GOTO 150
        IF(ITYP .GE. 0 .AND. IDECSV(IP) .EQ. 0) THEN
          NSTBMC = NSTBMC + 1
          ISTBMC(IP) = NSTBMC
          IDSTBL(NSTBMC) = IP
          IF(CHARGE(ITYP) .NE. 0.)NCHGMC = NCHGMC + 1
        ENDIF
150   CONTINUE

C-- # tracks gen. by qq
      NTRKMC = NTRKQQ

C-- # stable particles gen. by qq
      NSTBQQ = NSTBMC

C-- # charged stable part. gen. by qq
      NCHGQQ = NCHGMC

      RETURN
      END
