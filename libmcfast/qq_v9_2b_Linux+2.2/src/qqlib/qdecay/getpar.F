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
*CMZ :  1.04/00 22/09/94  00.14.23  by  Paul Avery
*CMZ :  1.03/70 08/10/93  16.26.57  by  Paul Avery
*CMZ :  1.02/00 02/11/90  00.37.52  by  Paul Avery
*CMZ :  1.00/00 25/06/90  21.59.45  by  Paul Avery
*CMZ :          19/05/90  14.51.01  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE GETPAR(IPD,IT,KID,XM,CMAS,NDAU,LIST,NP,NQ,KQ,ND,IER)
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqbrat.inc"

C     Calling arguments
      INTEGER IT, IER, NP, NQ, NDAU, LIST(*), ND, IPD
      INTEGER KID(30), KQ(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION CMAS
      DOUBLE PRECISION XM(30)
#else
      REAL CMAS
      REAL XM(30)
#endif
*
C     Local variables
      INTEGER I, J, IQRK, ID, ISEED, KT, NSUM
      INTEGER KQL(2,5)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PSUM
#else
      REAL PSUM
#endif

      COMMON/RANDM/ISEED
*
C     External declarations
#if defined(NONCLEO_DOUBLE)
      REAL RANP
      DOUBLE PRECISION GETMAS
#else
      REAL GETMAS, RANP
#endif
      EXTERNAL GETMAS, RANP
C  --------------------------------------------------------------------------

C  Get parameters for normal decay (MATRX >= 0)
      IER=0
      NP=0
      NQ=0

C  Unpack daughter particles stored in IDLIST
      DO 110 J=1,NDAU
        ID = LIST(J)

C  If qq decay, flag it for multiplicity change later (CNDE=....)
        IF(ID.LE.0)GOTO 109

C   ID > 0 ..... real particle
C   fill up first np slots in kid array. we will add particles generated
C   by qq generated particles later
        NP=NP+1
        KID(NP)=ID
        GOTO 110

C   ID < 0 ..... qq combination
C   KQ contains the quark types
109     NQ=NQ+1
        KQ(1,NQ)=(5-ID)/6
        KQ(2,NQ)=6*(KQ(1,NQ)-1)+ID
        IF(ID.NE.-37)GOTO 110
        KQ(1,NQ)=7
        KQ(2,NQ)=-KQ(1,NQ)
110   CONTINUE

C   generate masses and force sum of rest masses to be less than parent
      IF(NP.EQ.0)GOTO 130
      NSUM = 0
115   PSUM = 0.
      DO 125 I=1,NP
        XM(I)=GETMAS(KID(I))
        PSUM=PSUM+XM(I)
125   CONTINUE
      NSUM=NSUM+1
      IF(NSUM.GT.15)THEN
        IER=1
        RETURN
      ENDIF
      IF(PSUM.GT.CMAS)GOTO 115
130   ND=NDAU

C   find what class parent particle belongs to in order to pick
C   multiplicity parameters
C     IT = 1   ordinary su(3) particle, charm = 0 baryons
C     IT = 2   D, F, charmed baryons
C     IT = 3   B
C     IT = 4   T
C     IT = 5  virtual photon or "general" qq state

      KT=K(IPD,2)
      IT=1
      IF((KT.GE.27.AND.KT.LE.32).OR.(KT.GE.67.AND.KT.LE.72))IT=2
      IF((KT.GE.33.AND.KT.LE.40).OR.(KT.GE.73.AND.KT.LE.80))IT=3
      IF((KT.GE.41.AND.KT.LE.50).OR.(KT.GE.81.AND.KT.LE.90))IT=4
      IF(KT.EQ.0 .OR. KT.EQ.5)IT=5

C     For mesons we are done
      IF(KT.LT.121)RETURN

C  Put quark content of baryon into KQL(1,1-3)
      CALL KBQRK(KT,KQL)

C  Check if baryon contains charm
      DO 209 IQRK=1,3
        IF(IABS(KQL(1,IQRK)).EQ.4)IT=2
209   CONTINUE

C  Check if baryon contains bottom
      DO 210 IQRK=1,3
        IF(IABS(KQL(1,IQRK)).EQ.5)IT=3
 210  CONTINUE

      RETURN
      END
