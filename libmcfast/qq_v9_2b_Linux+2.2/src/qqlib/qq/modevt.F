*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.5  1996/05/21 16:26:44  clib
* Z smearing with Gaussian shape.  BSIZQQ(3) changed to 0.0127.
*
* Revision 1.4  1996/05/15 05:26:51  clib
* Save MODEL as IORGQQ in MCCOMS.
*
* Revision 1.3  1996/05/01 07:00:46  zfiles
* Initialize XANGQQ, BDISPX, BDISPY.
*
* Revision 1.2  1995/04/25  13:54:39  zfiles
* Initialize crossing angle
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.50.26  by  Peter C Kim
*CMZ :  1.03/62 23/03/93  16.12.26  by  Brian Heltsley
* put in FPAIR (mumuggg)
*CMZ :          14/12/92  16.07.23  by  Peter C Kim
*CMZ :  1.03/51 16/11/92  16.02.54  by  Unknown
*CMZ :  1.03/49 21/09/92  14.09.21  by  Peter C Kim
*CMZ :  1.03/31 22/11/91  13.38.31  by  B. Heltsley
* Put in BHLUMI
*CMZ :          23/07/91  02.57.19  by  Peter C Kim
*CMZ :  1.03/00 01/04/91  13.24.50  by  Peter C Kim
*CMZ :  1.02/00 09/02/91  14.14.05  by  Peter C Kim
*CMZ :  1.01/00 01/11/90  18.18.24  by  Paul Avery
*CMZ :  1.00/01 06/09/90  15.37.49  by  Paul Avery
*CMZ :  1.00/00 21/08/90  21.08.21  by  Paul Avery
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE MODEVT(IERR)

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqluns.inc"
#include "qqlib/seq/qqmxcp.inc"
#include "seq/clinc/qqbmst.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "seq/clinc/qqipcd.inc"
*
C-- External declarations
#if defined(NONCLEO_DOUBLE)
      REAL     RANP
      DOUBLE PRECISION QQGAUS
#else
      REAL     RANP, QQGAUS
#endif
      EXTERNAL RANP, QQGAUS

C-- Local variables
      INTEGER JJRES, I, L, NF, J, IC, NETRY
      INTEGER IERR, ITYPS(3,10), KCODE(-6:6)
      REAL    RANWID, RESMAS, RESWID, BW, RGAUNM, HZ1, HZ2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION R1, R2, P4CM(4), SIGZSB,SIGZ1,SIGZ2
      REAL    QFLM(6), FRAC2
#else
      REAL    QFLM(6), R1, R2, P4CM(4), SIGZSB,SIGZ1,SIGZ2,FRAC2
#endif
      DOUBLE PRECISION DP4PH(4)
      LOGICAL L1STRS

      SAVE QFLM, ITYPS, KCODE, L1STRS

C-- Data statements
      DATA QFLM/.3,.3,.4937,1.8633,5.25,35./
      DATA ITYPS/1,8,7,1,12,11,1,16,15,1,1,1,1,1,1,15*0/
      DATA KCODE/-12,-11,-10,-9,-8,-7,-13,-1,-2,-3,-4,-5,-6/
      DATA L1STRS/.TRUE./
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      IERR = 0
      NETRY = 0

C Copy crossing angle to MCCOMS
      IF(CRSANG.NE.0.0) XANGQQ = CRSANG
C Save MODEL as IORGQQ in MCCOMS
      IORGQQ = MODEL
C
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Put in machine resolution. Note that B&K outputs 4 vectors in units
C  of the once-fixed energy; thus they get scaled slightly incorrectly.
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      JJRES = 0

C   if model = 14, the energy variation along with the ratiative tail
C   is done in QMLUND.
C
      IF(MODEL.EQ.14.OR.MODEL.EQ.31) GOTO 6

 5      R1 = QQGAUS(0)
        R2 = QQGAUS(0)
        NETRY = NETRY + 1
        BEAMP = BMPSQQ + BWPSQQ * R1
        BEAMN = BMNGQQ + BWNGQQ * R2
        ENERNW = 2. * SQRT(BEAMP * BEAMN)
        IF(BWPSQQ.GT.0. .OR. BWNGQQ.GT.0.) THEN
          IF(ENERNW.LT.ENRGMN .OR. ENERNW.GT.ENRGMX) THEN
            IF(NETRY.GT.500) THEN
              WRITE(LTTOQQ,8888)
              WRITE(LOUTQQ,8888)
 8888         FORMAT(/,2X,'  E_CM outside the EMN/EMX boundaries? ')
              STOP
            ENDIF
            GOTO 5
          ENDIF
        ENDIF
        ECM = ENERNW

 6    CONTINUE

C     Fold in the Breit-Wigner shape for resonanace production if required
C        >>J. Lewis 8-June-1988
C
      IF (LRESPR) THEN
         JJRES = JJRES + 1
         IF (JJRES.GT.100) STOP
     *      'QQ: Resonance inappropriate for CM energy.'

         IF (L1STRS) THEN
            RESMAS = RESPRO(1)
            RESWID = RESPRO(2)**2
            L1STRS =.FALSE.
         ENDIF

         BW     = RESWID/(4.*(ECM-RESMAS)**2+RESWID)
         RANWID = RANP(0)
         IF (RANWID.GT.BW) GOTO 5
      ENDIF

      BEAMNW = ENERNW * 0.5

C-- Pick production vertex using gaussian to smear beam spot in x & y
C
C   BSIZQQ(I) = SIG_single_beam(I)/SQRT(2)
C
      DO 25 I=1,2
20       RGAUNM = RANP(0)
         IF(RGAUNM .EQ. 0)GOTO 20
         XVTX(1,I) = BPOSQQ(I) + BSIZQQ(I) * QQGAUS(0)
25    CONTINUE

      RVTX(1) = SQRT(XVTX(1,1)**2 + XVTX(1,2)**2)

C OLD parametrization.  Commented out.
CX-- Triangular distribution used to smear z beam spot position
CX      HZ1 = RANP(0)-0.5
CX      HZ2 = RANP(0)-0.5
CX      XVTX(1,3) = (HZ1+HZ2)*BSIZQQ(3) + BPOSQQ(3)
CX
CX-- time after beam crossing
CX      TVTX(1) = (HZ1-HZ2)*BSIZQQ(3) / 2.998E-4

C-- Redo Z smearing properly, using single beam Gaussian dstributions 
C   with an hourglass beam profile near Interaction region. 
C   (S. Milton, CBN 89-1)                                 PCK 5/15/96
C
C      SigZ_single_beam  = BSIZQQ(3)*sqrt(2)  :  ~18 mm
C      beta*_x = ~1000 mm  
C      beta*_y =   ~18 mm 
C
C   We will ignore beta*_x and assume that beta*_y = SigZ_single_beam
C   and parametrize the interaction probability distribution with a 
C   double Gaussian fit. 
C
      SIGZSB = BSIZQQ(3)*1.4142
      SIGZ1 = 0.671 * SIGZSB
      SIGZ2 = 0.469 * SIGZSB
      FRAC2 = 0.237

      IF(RANP(0).GT.FRAC2) THEN
        XVTX(1,3) = BPOSQQ(3) + SIGZ1*QQGAUS(0)
      ELSE
        XVTX(1,3) = BPOSQQ(3) + SIGZ2*QQGAUS(0)
      ENDIF

C-- Time after beam crossing (in picosecond) 
C   Not effected by the beam profile =>  Simple Gaussian distribution.

      TVTX(1) = BSIZQQ(3)*QQGAUS(0) / (2.0 * 2.998E-4)

      CALL VZERO (IPCDQQ, MCTRK)
      CALL VZERO (IPRNTV, MCTRK)
      CALL VZERO (IVPROD, MCTRK)
      CALL VZERO (IVDECA, MCTRK)
      CALL VZERO (IDKMEC, MCTRK)
      CALL VZERO (ITRKOU, MCVRTX)
      CALL VFILL (HELCQQ, MCTRK, -100.)
      CALL VZERO (ILDECA, 250)
#if defined(NONCLEO_DOUBLE)
      DO I=1,250
        CTTAU(I)=0.D0
      ENDDO
#else
      CALL VZERO (CTTAU,  250)
#endif

C--# Tracks
      NTRKQQ = 0

C--# vertices in event
      NVRTX = 1

C--track # into vertex
      ITRKIN(1) = 0

C--# tracks out of vertex
      NTRKOU(1) = 0

C--First track out of vertex
      ITRKOU(1) = 0

C--production vertex
      IVKODE(1) = 1

C--# quarks
      NC = 0

C--length of sjostrand list
      N = 0

C--first particle has no parent
      K(1,1) = 0

C-- Calculate CM 4-vector in CM
      P4CM(1) = 0.
      P4CM(2) = 0.
      P4CM(3) = 0.
      P4CM(4) = ENERNW

C     4-vector of original CM in lab
      P4CMQQ(1) = 0.
      P4CMQQ(2) = 0.
      P4CMQQ(3) = BEAMP - BEAMN
      P4CMQQ(4) = BEAMP + BEAMN

C-- initial state radiation ... scale 4-vector to beam energy

      IF(BMRAD .AND. (MODEL.LT.2.OR.MODEL.EQ.6) )  THEN

         CALL BREVNT(DP4PH)
         DO 10 L=1,4
           P4PHQQ(L) = DP4PH(L) * BEAMNW
10       CONTINUE

C     Boost photon into lab frame, calculate new cm 4-vector
         IF(P4PHQQ(4) .GT. 0.) THEN
           NTRKQQ = NTRKQQ + 1
           DO 11 L=1,4
             P4CM(L) = P4CM(L) - P4PHQQ(L)
11         CONTINUE

#if defined(NONCLEO_DOUBLE)
           CALL DBOOSF(P4CMQQ, 1, P4PHQQ, P4PHQQ)
#else
           CALL RBOOSF(P4CMQQ, 1, P4PHQQ, P4PHQQ)
#endif
           DO 15 L=1,4
             P4QQ(L,NTRKQQ) = P4PHQQ(L)
15         CONTINUE
           ITYPEV(NTRKQQ,1) = 1
           NTRKOU(1) = NTRKOU(1) + 1
           IF(ITRKOU(1) .EQ. 0) ITRKOU(1) = NTRKQQ
           IVPROD(NTRKQQ) = 1
         ENDIF

C     Boost e+e- CM 4-vector to lab frame
#if defined(NONCLEO_DOUBLE)
         CALL DBOOSF(P4CMQQ, 1, P4CM, P4CM)
#else
         CALL RBOOSF(P4CMQQ, 1, P4CM, P4CM)
#endif

         ECM = SQRT(P4CM(4)**2 - P4CM(1)**2 - P4CM(2)**2 - P4CM(3)**2)
#if defined(NONCLEO_DOUBLE)
	 do L=1,4
	   P4CMQQ(L) = P4CM(L)
	 enddo
#else
         CALL UCOPY(P4CM, P4CMQQ, 4)
#endif

C-- change made by roy cabenda, OCT. 3, 1981
C   determine number of active flavors
         NF = 0
         DO 30 I=1,6
            IF(2.*QFLM(I).LT.ECM) NF = NF + 1
   30    CONTINUE
         PAR(6) = FLOAT(NF)
      ENDIF

C-- flag if radiation
      IBMRAD = 0
      IF (BMRAD .AND. P4PHQQ(4) .GT. 0.)IBMRAD = 1

C-- choose models

      IF (MODEL.GT.5) GOTO 1300

      GOTO (1000,1100,1200,1200,1200,1200) MODEL+1

C-- QQ and GGG Jets
1000  CALL EVTGEN(IFL,ECM,IMODE,N,IERR)
      IF(IERR .NE. 0)RETURN

C-- Save primary partons
C       KCODE IS -12 -11 -10 -9 -8 -7  FOR TBAR .... UBAR
C                 -1  -2  -3 -4 -5 -6  FOR U  ...... T
C                -13  FOR GLUON

C     Boost partons to lab frame
      DO 1050 IC=1,NC
         NTRKQQ = NTRKQQ+1
         DO 1040 L=1,4
            P4QQ(L,NTRKQQ) = PC(IC,L)
 1040    CONTINUE
#if defined(NONCLEO_DOUBLE)
         CALL DBOOSF(P4CMQQ, 1, P4QQ(1,NTRKQQ), P4QQ(1,NTRKQQ))
#else
         CALL RBOOSF(P4CMQQ, 1, P4QQ(1,NTRKQQ), P4QQ(1,NTRKQQ))
#endif
         ITYPEV(NTRKQQ,1) = KCODE(KC(IC))
         NTRKOU(1) = NTRKOU(1) + 1
         IF(ITRKOU(1) .EQ. 0)ITRKOU(1) = NTRKQQ
         IVPROD(NTRKQQ) = 1
         IDECSV(NTRKQQ) = 0
         NDAUTV(NTRKQQ) = 0
         IDAUTV(NTRKQQ) = 0
 1050 CONTINUE

C     Boost primaries to lab frame and decay all particles
      CALL QQBST
      CALL DECADD
      RETURN

C-- Final states defined by a virtual photon
1100  N = N + 1

C-- Check if center of mass energy is compatible with this final state
C-- Primary particle is e+e- CM
C     IF(XMSUM.GT.ECM)GOTO 5

      DO 1110 L=1,4
         P(N,L) = P4CMQQ(L)
 1110 CONTINUE
      P(N,5) = ECM
      K(N,1) = 0
      K(N,2) = 0

C     Decay particles (no boost needed since primary is wrt lab)
      CALL DECADD
      RETURN

C-- QED models include photon already
1200  CALL QED999

C     Boost primaries to lab frame and decay all particles
      CALL QQBST
      CALL DECADD
      RETURN

1300  CONTINUE

C                                            KORALB
      IF (MODEL.EQ.7) THEN
                              CALL KORBEV
                              RETURN
      ENDIF
C                                            BHLUMI
      IF (MODEL.EQ.8) THEN
                              CALL BHLUEV
                              RETURN
      ENDIF
C                                            FPAIR
      IF (MODEL.EQ.9) THEN
                              CALL FPAREV
                              RETURN
      ENDIF

C                                            2 PHOTON
      IF (MODEL.EQ.6) THEN
                              CALL GGGEVT
                              RETURN
      ENDIF

C-- User defined model (all particles generated in e+e- CM)
C   Clear parents first

      IF (MODEL.EQ.10) THEN
        CALL VZERO(K(1,1), 250)
        IORGQQ = 10
        CALL MODUSR
        RETURN
      ENDIF


C---  EVENT GENERATION WITH LUND/JETSET

      IF (MODEL.GT.10.AND.MODEL.LE.20) THEN
              CALL QMLUND
              IORGQQ = 2
      ENDIF

C---  Single particle generation

      IF (MODEL.EQ.31) THEN

          CALL GNSNGL

      ENDIF

      RETURN
      END
