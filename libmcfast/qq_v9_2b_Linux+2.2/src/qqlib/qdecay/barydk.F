*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:41  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:29  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.12.54  by  Paul Avery
*CMZ :  1.00/00 14/06/90  14.26.27  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE BARYDK(ND,NP,NQ,CMAS,KID,XM,KQ,NTRYMX,IERR)
C.......................................................................
C.
C. BARYDK -
C.
C.       ND =  TOTAL NUMBER OF PARTICLES TO GENERATE
C.       NP =  # REAL PARTICLES INITIALLY
C.       NQ =  # QQ PAIRS INITIALLY
C.     CMAS =  MASS OF DECAYING OBJECT
C.****  KID =  PARTICLE ID ARRAY (START FILLING AT NP+1)
C.KQ(1-2,I) =  FLAVOR OF QUARK, ANTIQUARK IN QQ PAIR I  (1 =< I =< NQ)
C.   NTRYMX =  # TIMES TO TRY BEFORE QUITTING (BECAUSE OF REST MASS)
C.**** IERR =  1 IF TOTAL REST MASS LARGER THAN CMAS
C.
C. COMMON    : MCGEN
C.
C. Calls     :
C. Called    :
C.
C.  GENERATES PARTICLES FROM A QUARK SOUP WITH BARYON NUMBER = +/- 1.
C.  THE QUARKS CONSTITUTING THE BARYON ARE SPECIFIED BY KQ(1,K:K+2)
C.  WITH KQ(2,K:K+2) .EQ. 0 OR BY KQ(2,K:K+2) WITH KQ(1,K:K+2) .EQ. 0.
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
      INTEGER KID(30),KQ(2,5), ND, NP, NQ, NTRYMX, IERR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    XM(30), CMAS
#else
      REAL    XM(30), CMAS
#endif

*- External declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
      REAL     RANP
#else
      REAL     GETMAS, RANP
#endif
      INTEGER  KBPART, KPART
      EXTERNAL GETMAS, KBPART, KPART, RANP
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"

      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'BARYDK' )
*
      INTEGER IFL1(2,20),JBFL(2,3)
      INTEGER J, I, ITRY, NGEN, NNTRY, JT, IFL2, JPM, JPB
      INTEGER KODE, IDUMMY
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION    PSUMP, PSUM
#else
      REAL    PSUMP, PSUM
#endif
*
*
*- Executable code starts here
*
      IERR=0
      IF(NQ.EQ.0)RETURN

C-- Rest mass sum
      PSUMP=0.
      IF(NP.GT.0) THEN
         DO 101 J=1,NP
            PSUMP=PSUMP+XM(J)
  101    CONTINUE
      ENDIF

      ITRY=0
  201 IF (ITRY.LT.NTRYMX) THEN
         ITRY=ITRY+1
         PSUM = PSUMP
         DO 202 I=1,NQ
            IFL1(1,I) = KQ(1,I)
            IF (IFL1(1,I).EQ.0) IFL1(1,I) = ISIGN(99,-KQ(2,I))
            IFL1(2,I) = KQ(2,I)
            IF (IFL1(2,I).EQ.0) IFL1(2,I) = ISIGN(99,-KQ(1,I))
  202    CONTINUE

         NGEN = ND-(NP+NQ-2)
         NNTRY = NQ
         IF (NGEN.GT.0) THEN
            DO 203 I=1,NGEN
               JT = 1+NNTRY*RANP(ISEED)
               IFL2 = ISIGN(1+INT(RANP(ISEED)/PUD),-IFL1(1,JT))
               NNTRY = NNTRY+1
               IFL1(1,NNTRY) =  IFL1(1,JT)
               IFL1(2,NNTRY) =  IFL2
               IFL1(1,JT)    = -IFL2
  203       CONTINUE
         ENDIF

         JPM = NP
         JPB = 0
         DO 204 I=1,NNTRY

C-- CONDITIONAL
            IF     (IABS(IFL1(2,I)).EQ.99) THEN
               JPB = JPB+1
               JBFL(1,JPB) = IFL1(1,I)

            ELSEIF (IABS(IFL1(1,I)).EQ.99) THEN
               JPB = JPB+1
               JBFL(1,JPB) = IFL1(2,I)

C-- (OTHERWISE)

            ELSE
               KODE = 6*MAX0(IFL1(1,I),IFL1(2,I))
     +                 -MIN0(IFL1(1,I),IFL1(2,I))-6
               JPM = JPM+1
               KID(JPM) = KPART(KODE,IDUMMY)
               XM(JPM)  = GETMAS(KID(JPM))
               PSUM = PSUM+XM(JPM)
            ENDIF
  204    CONTINUE

         JPM = JPM+1
         KID(JPM) = KBPART(JBFL)
         XM(JPM)  = GETMAS(KID(JPM))
         PSUM     = PSUM+XM(JPM)

         IF(PSUM.LT.CMAS)RETURN
         GOTO 201
      ENDIF

C-- If rest masses too large, set error flag and return
      IERR=1

      RETURN
      END
