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
*CMZ :  1.04/00 22/09/94  00.15.16  by  Paul Avery
*CMZ :  1.03/70 08/10/93  17.05.25  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.25  by  Paul Avery
*CMZ :          19/05/90  14.51.02  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE SEMI(NP,NQ,KID,XM,KQ,KPAR,CMAS,T,IT,ND,PQ,MATRX,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C   PROCESS SEMILEPTONIC DECAYS ..... MATRX = 1, 2

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcjet.inc"
#include "qqlib/seq/qqcntl.inc"

C     Calling arguments
      INTEGER NP, NQ, KPAR, IT, ND, MATRX, IER
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION T(4), XM(30), PQ(4,30)
      DOUBLE PRECISION CMAS
#else
      REAL T(4), XM(30), PQ(4,30)
      REAL CMAS
#endif
*
C     Local variables
      INTEGER IERR, J, ND1, ND2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CORR, PSUM, SUBMS2, CNDE, CMEAN, WID, SUBMS1
      DOUBLE PRECISION XMT(3)
#else
      REAL CORR, PSUM, SUBMS2, CNDE, CMEAN, WID, SUBMS1
      REAL XMT(3)
#endif
*
C     External declarations
      INTEGER MLTGEN
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION FMAS2
#else
      REAL FMAS2
#endif
      EXTERNAL MLTGEN, FMAS2

      COMMON/BLOB1/ND1,ND2,SUBMS1,SUBMS2
C  ----------------------------------------------------------------------------

      IER = 0
      IF(MATRX-2)1000,1500,4000

C   MATRX = 1 .... quark fragments into hadrons
1000  ND=3
      IF(NQ.EQ.0)GOTO 1005
      CALL DECQRK(ND,NP,NQ,CMAS,KID,XM,KQ,1000,IER)
      IF ( IER .NE. 0 ) RETURN
1005  IF(LPHASE)CALL PHSP(T,CMAS,1,ND,XM,PQ)
      RETURN

C   MATRX = 2 .... fragment hadronic blob
1500  PSUM=0.

C   Minimum mass
      CORR=CQMAS(KQ(1,1))+CQMAS(-KQ(2,1))
      DO 1505 J=1,2
      PSUM=PSUM+XM(J)
1505  CONTINUE
      ND=NP
      ND1=ND-2
      IF(NQ.EQ.0)GOTO 1525

C   Generate blob submass
1510  SUBMS2=FMAS2(CORR,CMAS-PSUM,CEN(2),FWID(2))
#if defined(NONCLEO_DOUBLE)
      CNDE=C1B(2)*DLOG((SUBMS2-CORR)/C2B(2))
      CMEAN=.5*(NP-2+NQ)+CNDE
      WID=SQRT(DMAX1(CNDE*WIDTH(IT),.00001D0))
#else
      CNDE=C1B(2)*ALOG((SUBMS2-CORR)/C2B(2))
      CMEAN=.5*(NP-2+NQ)+CNDE
      WID=SQRT(AMAX1(CNDE*WIDTH(IT),.00001))
#endif

C   Generate multiplicity
1520  ND1=MLTGEN(CMEAN,WID,NP-2+NQ,10)
      ND=ND1+2

C   Form hadrons from quarks
      CALL DECQRK(ND,NP,NQ,SUBMS2+PSUM,KID,XM,KQ,5,IERR)
      IF(IERR.EQ.0)GOTO 1525

C   If error, process according to multiplicity
      IF(ND-3)1510,1510,1520

C   If 3 body, can only use mass of hadron
1525  IF(ND.EQ.3)SUBMS2=XM(3)
      XMT(1)=XM(1)
      XMT(2)=XM(2)
      XMT(3)=SUBMS2

C   Do semileptonic decay using hadronic blob as single particle
      IF(LPHASE)CALL PHSP(T,CMAS,1,3,XMT,PQ)
      IF(ND.EQ.3)RETURN

C   Decay blob into its constituent hadrons
      IF(LPHASE)CALL PHSP(PQ(1,3),SUBMS2,0,ND1,XM(3),PQ(1,3))

4000  RETURN
      END
