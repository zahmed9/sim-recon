*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:42  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 04/10/94  17.14.20  by  Paul Avery
*CMZ :  1.03/73 17/12/93  16.53.16  by  Peter C Kim
*CMZ :  1.03/71 02/12/93  13.06.25  by  Lynn Garren
*CMZ :  1.03/70 08/10/93  16.35.40  by  Paul Avery
*CMZ :  1.03/56 14/12/92  13.31.31  by  Peter C Kim
*CMZ :  1.03/45 27/04/92  15.50.52  by  Peter C Kim
*CMZ :  1.03/39 14/01/92  19.16.56  by  Peter C Kim
*CMZ :  1.02/00 12/03/91  15.13.05  by  Peter C Kim
*CMZ :  1.00/01 06/09/90  15.40.03  by  Paul Avery
*CMZ :  1.00/00 21/08/90  21.08.22  by  Paul Avery
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
* 15/10/96 Lynn Garren: Add double precision conditionals.
* 13/11/96 Lynn Garren:  Add check for attempted decays of massless particles.
*
      SUBROUTINE DECADD

*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*    Decay particles and add them to end of list until everything
*    is decayed.
*
*  Magnetic field unit and sign changed.   27/04/92  PCK
*  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
*
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "seq/clinc/qqbfld.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqfile.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"
#if defined(NONCLEO_DOUBLE)
#include "qqlib/seq/qqluns.inc"
#endif

*- External declarations
      REAL     RANP
      EXTERNAL RANP
*
C-- Local variables
      INTEGER I, L, J, IPD, IPUT, IPUTSV, ICHAN
      INTEGER IOFSET, NDAU, IDAU, IT, ITYP, IV, IP, IC
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PP, FACT, A, SINPS, COSPS, DCOSPS, PX, PY
      DOUBLE PRECISION TMASSQ
      REAL R
#else
      REAL PP, R, FACT, A, SINPS, COSPS, DCOSPS, PX, PY
#endif
*
C-- Executable code starts here-----------------------------------------------

      IPD    = 0
      IPUT   = N
2050  IPD    = IPD + 1
      IF(IPD.GT.IPUT .OR. IPUT.GE.MCTRK-3) GOTO 8000

      IPUTSV = IPUT
      ICHAN  = 0
      IOFSET = IPUT - IPD + 1
      ITYP = K(IPD,2)

      NTRKQQ = NTRKQQ + 1
      DO 2060 L=1,4
        P4QQ(L,NTRKQQ) = P(IPD,L)
2060  CONTINUE
      ITYPEV(NTRKQQ,1) = ITYP
      IT = NTRKQQ
      PP = SQRT(P4QQ(1,IT)**2 + P4QQ(2,IT)**2 + P4QQ(3,IT)**2)

C-- If primary particle, add to primary vertex list
      IF(IPRNTV(NTRKQQ) .EQ. 0) THEN
        NTRKOU(1) = NTRKOU(1) + 1
        IVPROD(NTRKQQ) = 1
        IF(ITRKOU(1) .EQ. 0)ITRKOU(1) = NTRKQQ
      ENDIF

C     Stable particle
      IF(IPLIST(1,ITYP) .EQ. 0) THEN
        NDAUTV(NTRKQQ) = 0
        IDAUTV(NTRKQQ) = 0
        IDECSV(NTRKQQ) = 0
        IVDECA(NTRKQQ) = 0

C     Decay unstable particle
      ELSE
C-- Long-lived particles are not decayed.

        IF(.NOT.LONGLF.AND.CTAU(ITYP).GT.0.01) THEN
          NDAUTV(NTRKQQ) = 0
          IDAUTV(NTRKQQ) = 0
          IDECSV(NTRKQQ) = 0
          IVDECA(NTRKQQ) = 0
          GOTO 2100
        ENDIF

#if defined(NONCLEO_DOUBLE)
C-- Check validity of particle mass
        TMASSQ = P(IPD,4)**2-P(IPD,2)**2-P(IPD,3)**2-P(IPD,1)**2
        IF(TMASSQ .LT. 0.D0) THEN
          NDAUTV(NTRKQQ) = 0
          IDAUTV(NTRKQQ) = 0
          IDECSV(NTRKQQ) = 0
          IVDECA(NTRKQQ) = 0
          WRITE(LTTOQQ,1001) K(IPD,2)
          GOTO 2100
        ENDIF
 1001   FORMAT(' DECADD: particle ',I4,' will not be decayed',
     1         ' - generated mass is unphysical')
#endif

C-- Generate lifetime/mass
C. Check for B0 decays -- pdr oct 1990
        IF (CTTAU(IPD) .NE. 0.) THEN
          FACT = CTTAU(IPD) / AMASS(ITYP)
        ELSE IF (CTAU(ITYP) .EQ. 0.) THEN
          FACT = 0.
        ELSE IF(CTAU(ITYP) .GT. 0.) THEN
120       R = RANP(0)
          IF(R .EQ. 0)GOTO 120
          FACT = -CTAU(ITYP)/AMASS(ITYP) * ALOG(R)
        ENDIF

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
C
C-- Make new decay vertex. IV is the production vertex of this particle
        NVRTX = NVRTX + 1
C
C-- Magnetic field unit in Tesla
C                                      Default value BFLDQQ = 1.5
C
CC        A = -0.2998 * CHARGE(ITYP) * BFLDQQ
C
C-- Magnetic field unit changed to KGauss with correct sign.
C                                      Default value BFLDQQ = -15.0
C                                      27/04/92 PCK
C
CC        A =  0.02998 * CHARGE(ITYP) * BFLDQQ
C
C-- The extra sign introduced when BFLDQQ went from 1.5 to -15.0
C   was not needed, since the BFLDQQ should have been -1.5 to start with.
C
C                                      Default value BFLDQQ = -15.0
C                                      16/12/93 PCK
C
        A =  -0.02998 * CHARGE(ITYP) * BFLDQQ
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
     *                    P4QQ(2,IT)/A * DCOSPS
          XVTX(NVRTX,2) = XVTX(IV,2) + P4QQ(2,IT)/A * SINPS +
     *                    P4QQ(1,IT)/A * DCOSPS
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
