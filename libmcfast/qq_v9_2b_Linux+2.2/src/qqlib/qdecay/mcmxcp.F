*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:30  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.14.36  by  Paul Avery
*CMZ :  1.02/00 22/11/90  15.18.54  by  Phil Rubin
*CMZ :          12/10/90  08.54.49  by  Phil Rubin
* 30/10/96 Lynn Garren:  Add double precision conditionals.
*                        Note that XLIST is unused.
      SUBROUTINE MCMXCP(IPD, ND, IDPRNT)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  MCMXCP does mixing and CP violation through the mixing mechanism
C
C  IPD      integer variable (read)
C           Position of parent particle in K list
C
C  ND       integer variable (read)
C           Number of daughters
C
C  IDPRNT   integer variable (read)
C           Decay channel of parent (position in BRLIST)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"

C     Calling arguments
      INTEGER IPD, ND, IDPRNT

C     External declarations
      REAL     RANP
      EXTERNAL RANP

C     Local variables
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'MCMXCP' )
      INTEGER MLIST
      PARAMETER (MLIST = 200)

      INTEGER I, ID, ID1, ID2, ITPAR, ICO, IDC, ICHAN, ICPIDC, ITAG
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CTTI(2), DCTT, SCTT, CTT, PNMX, XMIX, SINPHI
      DOUBLE PRECISION CT, T12, ASYM
      REAL XRND
#else
      REAL XRND, CTTI(2), DCTT, SCTT, CTT, PNMX, XMIX, SINPHI, ASYM
      REAL CT, T12, XLIST(MLIST)
#endif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C. Parent type
      ITPAR = K(IPD,2)

C. Charge parity of parent
      ICO = CPARTY(ITPAR)

C. Assign particle (anti-particle) identification 1 (2)
      ID1 = K(IPD+1,2)
      ID2 = K(IPD+2,2)

C. Two possible cases
C.  1. ND = 2, coherent state (C parity .NE.+-1), daughters mix into each other
C.  2. All others; mixing handled independently for each particle
      IF(ND.NE.2 .OR. ND.EQ.2 .AND.
     *                (ABS(ICO).NE.1 .OR.IMIXPP(ID1).NE.ID2) ) THEN

C. Case 2   P(t) = exp(-t/tau) * [1 + cos(x*t/tau)] / 2  (Particle)
C.          P(t) = exp(-t/tau) * [1 - cos(x*t/tau)] / 2  (Antiparticle)
        DO 20 I=1,ND
          ID = K(IPD+I,2)
C.***PDR***   IF(CTAU(ID).LE.0. .OR. RMIXPP(ID) .EQ. 0.) GOTO 20
          IF(CTAU(ID)       .LE. 0. .OR.
     1       CTTAU(IPD + I) .NE. 0. .OR.
     2       RMIXPP(ID)     .EQ. 0.) GOTO 20
C.***PDR***
          CT = -CTAU(ID) * ALOG(RANP(0))
          IF(RANP(0) .GT. 0.5*(1. + COS(RMIXPP(ID)*CT/CTAU(ID)))) THEN
            K(IPD+I,2) = IMIXPP(ID)
          ENDIF
          CTTAU(IPD+I) = CT
20      CONTINUE
        GOTO 1000
      ENDIF

C. Case 1: Coherent mixing
C. Quit if no mixing or daughters do not mix into each other
      IF(IMIXPP(ID1).NE.ID2 .OR. RMIXPP(ID1).EQ.0.) GOTO 1000
      XMIX = RMIXPP(ID1)

C. It is necessary to decay both particles in advance. If there is CP
C. violation in addition to mixing, then we must know the magnitude of
C. sin(phi), the CP parameter describing the magnitude of CP violation.

C. Get decay lengths, their differences, and their sums
      CTTI(1) = -CTAU(ID1) * ALOG(RANP(0))
      CTTI(2) = -CTAU(ID2) * ALOG(RANP(0))
      DCTT    = CTTI(2) - CTTI(1)
      SCTT    = CTTI(2) + CTTI(1)
C
C. If CP eigenstates defined for both particles, use CP formalism
      IF(IPLIST(4,ID1).GT.0 .AND. IPLIST(4,ID2).GT.0) THEN

C. Pick out a CP decay using branching fractions
        IDC = IPLIST(3,ID1) - 1
        XRND = RANP(0)
80      IDC = IDC + 1
        IF(CPLIST(IDC) .LT. XRND) GOTO 80
        ICPIDC = ICPLST(IDC)

C. CP asymmetry
        SINPHI = CPSNPH(IDC)

C.     f  = CP eigenstate
C.     T  = tag for B0
C.     TB = tag for B0B
C.     F  = exp[-Gam(t1+t2)] * |A|**2 * |B|**2 * (1 + |r|**2) / 2
C.     A  = <f|Hw|B0>
C.     AB = <f|Hw|B0B>
C.     B  = <T|Hw|B0>
C.     r  = AB / A
C.     diff = (1 - |r|**2) / (1 + |r|**2)
C.     eps = (p/q) * A*(AB*) * (|A|**2 + |AB|**2)
C.
C.  Note that for 1 amplitude, |r| = 1, diff = 0, Im(eps) = sin(2phi)
C.
C. For odd C state there are 4 possibilities (dt = t2 - t1)
C. N1 = f(t1)  T(t2)  = F * {1 - diff*cos(DM*dt) + sin(DM*dt)*Im(eps)}
C. N2 = T(t1)  f(t2)  = F * {1 - diff*cos(DM*dt) - sin(DM*dt)*Im(eps)}
C. N3 = f(t1)  TB(t2) = F * {1 + diff*cos(DM*dt) - sin(DM*dt)*Im(eps)}
C. N4 = TB(t1) f(t2)  = F * {1 + diff*cos(DM*dt) + sin(DM*dt)*Im(eps)}

        IF (ICO .EQ. -1) THEN
C
C. Prob(RAN > ASYM) = 1 - sin(2phi)*sin(DM*dt)  (N2 & N3)
C. Prob(RAN < ASYM) = 1 + sin(2phi)*sin(DM*dt)  (N1 & N4)
          XRND = 2. * RANP(0) - 1.0
          ASYM = SINPHI * SIN(XMIX * DCTT / CTAU(ID1))
C.***PDR*** 22 Nov 1990
          IF(XRND .GT. ASYM) THEN
            CTT     = CTTI(1)
            CTTI(1) = CTTI(2)
            CTTI(2) = CTT
          ENDIF
          IF(DCTT .LT. 0) THEN
            ITAG = ID2
          ELSE
            ITAG = ID1
          ENDIF
C.***PDR***
C
C. For even C state there are 4 possibilities (st = t2 + t1)
C. N1 = f(t1)  T(t2)  = F * {1 - diff*cos(DM*st) + sin(DM*st)*Im(eps)}
C. N2 = T(t1)  f(t2)  = F * {1 - diff*cos(DM*st) + sin(DM*st)*Im(eps)}
C. N3 = f(t1)  TB(t2) = F * {1 + diff*cos(DM*st) - sin(DM*st)*Im(eps)}
C. N4 = TB(t1) f(t2)  = F * {1 + diff*cos(DM*st) - sin(DM*st)*Im(eps)}

        ELSE IF(ICO .EQ. +1) THEN
C
C. Prob(RAN > ASYM) = 1 - sin(2phi)*sin(DM*st)  (N2 & N3)
C. Prob(RAN < ASYM) = 1 + sin(2phi)*sin(DM*st)  (N1 & N4)
          XRND = 2. * RANP(0) - 1.0
          ASYM = SINPHI * SIN(XMIX * SCTT / CTAU(ID1))
          IF(XRND .GT. ASYM) THEN
            ITAG = ID2
          ELSE
            ITAG = ID1
          ENDIF
C
C. End C state check
        ENDIF
C
C. Decay tagging particle (but not into CP eigenstate if CPTAG set)
59        XRND = RANP(0)
          IDC = IPLIST(1,ITAG) - 1
60        IDC = IDC + 1
          IF(XRND .GT. BRLIST(IDC)) GOTO 60
          IF(LCPTAG(IDPRNT) .AND. MLLIST(8,IDC).GT.0) GOTO 59
C.***PDR*** 22 NOV 1990
          IF (ITAG .EQ. ID1) THEN
             ILDECA(IPD+2) = ICPIDC
             ILDECA(IPD+1) = IDC
          ELSE
             ILDECA(IPD+1) = ICPIDC
             ILDECA(IPD+2) = IDC
          ENDIF
C.***PDR***
C
C. Fill in decay length
          CTTAU(IPD+1) = CTTI(1)
          CTTAU(IPD+2) = CTTI(2)
C
C. If no CP, then do mixing. Use t12 = t1 +- t2
C. Using equations for coherent state, we have 4 possible final states
C.   B0  B0B   P(t1,t2) = exp[-(t1+t2)/tau] * [1 + cos(x*t12] / 4
C.   B0B B0    P(t1,t2) = exp[-(t1+t2)/tau] * [1 + cos(x*t12] / 4
C.   B0  B0    P(t1,t2) = exp[-(t1+t2)/tau] * [1 - cos(x*t12] / 4
C.   B0B B0B   P(t1,t2) = exp[-(t1+t2)/tau] * [1 - cos(x*t12] / 4
C.
C.  We consider the first two to be equivalent and correspond to no mixing

      ELSE
C
C. Calculate probability of B0 B0 or B0B B0B; compare with random number [0, 1]
        IF(ICO .EQ. +1) THEN
          T12 = SCTT
        ELSE
          T12 = DCTT
        ENDIF

        PNMX = 0.5 * (1. + COS(XMIX * T12 / CTAU(ID2)))

        IF (RANP(0) .GT. PNMX) THEN
          IF(RANP(0) .GT. 0.5) THEN
            K(IPD+1,2) = ID1
            K(IPD+2,2) = ID1
          ELSE
            K(IPD+1,2) = ID2
            K(IPD+2,2) = ID2
          ENDIF
        ENDIF

        CTTAU(IPD+1) = CTTI(1)
        CTTAU(IPD+2) = CTTI(2)
C
C. End CP, mixing check
      ENDIF

C     Only exit
1000  RETURN
      END
