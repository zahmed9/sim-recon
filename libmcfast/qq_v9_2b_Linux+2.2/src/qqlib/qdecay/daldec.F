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
*CMZ :  1.03/67 19/07/93  18.32.41  by  Peter C Kim
*CMZ :  1.03/66 22/06/93  12.08.31  by  Alan Weinstein
*CMZ :  1.03/65 22/06/93  11.23.15  by  Alan Weinstein
*-- Author :    Alan Weinstein   22/06/93
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE DALDEC(NP,NQ,KID,XM,KQ,ID,CMAS,T,IT,ND,PQ,MATRX,IER)
C.......................................................................
C.
C. DALDEC - Decay of pi0 or eta --> gamma e+e- with proper matrix element
C.
C. Calls     :
C. Called    : DECAY
C. Author    : Alan Weinstein 18/06/93
C.
C.  Calls to HBOOK commented out (was giving problem on DEC stations)
C.                                                 PCK 19/07/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KID(30),KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      DOUBLE PRECISION    CMAS
#else
      REAL    T(4),XM(30),PQ(4,30)
      INTEGER NP, NQ, ID, IT, ND, MATRX, IER
      REAL    CMAS
#endif
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DALDEC' )

C  Local Variables

      INTEGER I
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION XMESQ,XMPI0,XMROSQ,XGROSQ,XMMNSQ,XMMXSQ,XMEESQ
      DOUBLE PRECISION WT,EE,PE,COSTH,SINTH,THETA,PHI,P1P2,P1P3
      DOUBLE PRECISION PCM(4,4),TO(4),PEE(4,2)
#else
      REAL XMESQ,XMPI0,XMROSQ,XGROSQ,XMMNSQ,XMMXSQ,XMEESQ
      REAL WT,EE,PE,COSTH,SINTH,THETA,PHI,P1P2,P1P3
      REAL PCM(4,4),TO(4),PEE(4,2)
#endif

      PARAMETER (XMESQ=0.000511**2)
      PARAMETER (XMMNSQ=4.*XMESQ)
      PARAMETER (XMROSQ=0.770**2)
      PARAMETER (XGROSQ=0.150**2)

      REAL  RANP
      EXTERNAL RANP
      LOGICAL FIRST
      DATA FIRST/.TRUE./
*
********************************************************************
*
      IF (FIRST) THEN
        FIRST = .FALSE.
CX        CALL HBOOK1(9001,'pi0 mass',40,0.,1.,0.)
CX        CALL HBOOK1(9002,'pi0 Energy',60,0.,6.,0.)
CX        CALL HBOOK1(9003,'pi0 wt1 ',100,0.,2.,0.)
CX        CALL HBOOK1(9004,'M_EE    ',70,0.,0.140,0.)
CX        CALL HBOOK1(9005,'pi0 wt2 ',100,0.,2.,0.)
CX        CALL HBOOK1(9006,'M_EG    ',70,0.,0.140,0.)
C
CX        CALL HIDOPT(0,'STAT')
      END IF
*
C--- Do we have a pi0 or eta ?

      IER = 1
      IF (ID .NE. 51 .AND. ID.NE.52)  RETURN

C---  Procedure:  1) generate m_ee distribution, accept/reject
C---              2) do two sequential 2-body decays, form 4-vectors
C---              3) accept/reject with remaining weight
C---              4) rotate and boost to lab

      XMPI0  = CMAS
      XMMXSQ = XMPI0**2
CX      CALL HFILL(9001,CMAS,0.,1.)
CX      CALL HFILL(9002,T(4),0.,1.)

C-  1) generate m_ee distribution, accept/reject
  10  XMEESQ = XMMNSQ*(XMMXSQ/XMMNSQ)**RANP(0)
      WT=(1+0.5*XMMNSQ/XMEESQ)*
#if defined(NONCLEO_DOUBLE)
     1   SQRT(MAX(0.D0,1.D0-XMMNSQ/XMEESQ))*
#else
     1   SQRT(MAX(0.,1.-XMMNSQ/XMEESQ))*
#endif
     2   (1.-XMEESQ/XMMXSQ)**3*
     3   (1.+XGROSQ/XMROSQ)/((1.-XMEESQ/XMROSQ)**2+XGROSQ/XMROSQ)
CX      CALL HFILL(9003,WT,0.,1.)
      IF(WT.LT.RANP(0)) GOTO 10
CX      CALL HFILL(9004,2.*EE,0.,1.)
C
      EE = SQRT(XMEESQ)/2.
#if defined(NONCLEO_DOUBLE)
      PE = SQRT(MAX(0.D0,EE**2-XMESQ))
#else
      PE = SQRT(MAX(0.,EE**2-XMESQ))
#endif

C- 2) do two sequential 2-body decays, form 4-vectors
C
C photon momentum
      PCM(1,1) = 0.
      PCM(2,1) = 0.
      PCM(4,1) = (XMMXSQ-XMEESQ)/(2.*XMPI0)
      PCM(3,1) = PCM(4,1)
C ee-system momentum
      PCM(1,4) = 0.
      PCM(2,4) = 0.
      PCM(4,4) = (XMMXSQ+XMEESQ)/(2.*XMPI0)
      PCM(3,4) = -PCM(4,1)
C
C-decay ee-system:
  20  COSTH = 2*RANP(0)-1.
      PHI = 2.*3.141592654*RANP(0)
#if defined(NONCLEO_DOUBLE)
      SINTH = SQRT(MAX(0.D0,1.-COSTH**2))
#else
      SINTH = SQRT(MAX(0.,1.-COSTH**2))
#endif

C form e+ and e- 4-vectors in ee frame
      PEE(1,1) = PE*SINTH*COS(PHI)
      PEE(2,1) = PE*SINTH*SIN(PHI)
      PEE(3,1) = PE*COSTH
      PEE(4,1) = EE
      PEE(1,2) = -PEE(1,1)
      PEE(2,2) = -PEE(2,1)
      PEE(3,2) = -PEE(3,1)
      PEE(4,2) = EE

C lorentz transform to pi0 frame
      DO 110 I=1,4
        TO(I)=PCM(I,4)
 110  CONTINUE
      CALL BOOSTF(TO,2,PEE,PCM(1,2))

C- 3) accept/reject with remaining weight
      P1P2 = PCM(4,1)*PCM(4,2)-PCM(1,1)*PCM(1,2)-
     1       PCM(2,1)*PCM(2,2)-PCM(3,1)*PCM(3,2)
      P1P3 = PCM(4,1)*PCM(4,3)-PCM(1,1)*PCM(1,3)-
     1       PCM(2,1)*PCM(2,3)-PCM(3,1)*PCM(3,3)
      WT = (XMEESQ-0.5*XMMNSQ)*(P1P2**2+P1P3**2)+
     1     XMMNSQ*(P1P2*P1P3+P1P2**2+P1P3**2)
      WT = WT/(0.25*XMEESQ*(XMMXSQ-XMEESQ)**2)
CX      CALL HFILL(9005,WT,0.,1.)
      IF (WT.LT.RANP(0)) GOTO 20
CX      CALL HFILL(9006,SQRT(MAX(0.,2.*P1P2)),0.,1.)
C
C- 4) rotate and boost to lab
C rotation
      COSTH = 2*RANP(0)-1.
      PHI = 2.*3.141592654*RANP(0)
      THETA = ACOS(COSTH)
      CALL ROTAT(PHI,THETA,-PHI,3,PCM,PCM)

C lorentz transform to lab system
      DO 120 I=1,4
        TO(I)=T(I)
 120  CONTINUE
      CALL BOOSTF(TO,3,PCM,PQ)

      IER = 0
      RETURN
      END
