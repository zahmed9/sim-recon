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
*CMZ :  1.04/00 22/09/94  00.14.14  by  Paul Avery
*CMZ :  1.00/00 26/07/90  20.34.05  by  Paul Avery
*CMZ :          19/05/90  14.51.03  by  Jorge L. Rodriguez
*>> Author :
* 16/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE DECQRK(ND,NP,NQ,CMAS,KID,XM,KQ,NTRYMX,IERR)
C.......................................................................
C.
C. DECQRK -  Generate and pair off quark-antiquark pairs
C.
C.       ND = TOTAL NUMBER OF PARTICLES TO GENERATE
C.       NP = # REAL PARTICLES INITIALLY
C.       NQ = # QQ PAIRS INITIALLY
C.     CMAS = MASS OF DECAYING OBJECT
C.****  KID = PARTICLE ID ARRAY (START FILLING AT NP+1)
C.KQ(1-2,I) = FLAVOR OF QUARK, ANTIQUARK IN QQ PAIR I  (1 =< I =< NQ)
C.   NTRYMX = # TIMES TO TRY BEFORE QUITTING (BECAUSE OF REST MASS)
C.**** IERR = 1 IF TOTAL REST MASS LARGER THAN CMAS
C.
C. COMMON    : MCGEN
C.
C. Calls     : DIQFLV
C. Called    :
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
*
      INTEGER   KID(30), KQ(2,5), ND, NP, NQ, NTRYMX, IERR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION      XM(30), CMAS
#else
      REAL      XM(30), CMAS
#endif
*
*- External declarations
      INTEGER   KBPART, KPART
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS
      REAL      RANP
#else
      REAL      GETMAS, RANP
#endif
      EXTERNAL  GETMAS, KBPART, KPART, RANP
*
*- Sequence declarations
#include "qqlib/seq/mcgen.inc"
      INTEGER ISEED
      COMMON/RANDM/ISEED
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DUM' )

      INTEGER   IFL1(4),ITV(2,3)
      INTEGER   ITRY, I, J, I1, JTP, NBARP, MXBRPR, JT, JTB
      INTEGER   IFL2, IQ, ITT, JTT, IBAR, JSGN, JQ, IDUM
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION      PSUMP, PSUM
#else
      REAL      PSUMP, PSUM
#endif
*
*
*- Executable code starts here
*
      IERR=0
      IF(NQ.EQ.0)RETURN

C-- Rest mass sum
      PSUMP=0.
      IF(NP.EQ.0)GOTO 60
      DO 50 J=1,NP
50       PSUMP=PSUMP+XM(J)

60    ITRY=0
70    ITRY=ITRY+1

C-- Fill up quark array IFL1(4)
      DO 130 I=1,NQ
         I1=2*I
         IF(KQ(1,I).EQ.7) GOTO 120
         IFL1(I1-1) = KQ(1,I)
         IFL1(I1)   = KQ(2,I)
         GOTO 130

C-- General QQ state .... generate UU, DD, or SS pair
120      IFL1(I1-1) = 1+INT(RANP(ISEED)/PUD)
         IFL1(I1)   = -IFL1(I1-1)
130   CONTINUE

      JTB = 0
      NBARP = 0
      IF(ND.EQ.NP+NQ) GO TO 150
      MXBRPR = PAR(18)

      DO 140 I1=NP+1,ND-NQ

C-- Decide which quark (qbar) to use >>>>>>>>>>
         JT = MIN(1+INT(2*NQ*RANP(ISEED)),4)
         IF(JTB.NE.0) GO TO 148
         IF (NBARP.LT.MXBRPR) THEN
            IF(FLIP.GT.RANP(ISEED)) GOTO 146
         ENDIF

C-- Extract quark pair,  form a meson  >>>>>>>>
142      IFL2=ISIGN(1+INT(RANP(ISEED)/PUD), -IFL1(JT))
         KID(I1)=6*MAX0(IFL1(JT),IFL2)-MIN0(IFL1(JT),IFL2)-6
         IFL1(JT) = -IFL2
         GOTO 140

C-- Extract diquark pair,  form a baryon  >>>>-
146      CALL DIQFLV(IFL2)

C-- Store quark flavors in KID for now
         KID(I1)  = IQFLV(1,IFL2)+16*IQFLV(2,IFL2)+256*IABS(IFL1(JT))
         KID(I1)  = ISIGN(KID(I1),IFL1(JT))
         IFL1(JT) = ISIGN(IFL2+9, -IFL1(JT))
         JTB = JT
         NBARP = NBARP+1
         GOTO 140

C-- Use up existing diquark, form a baryon >>-
148      IFL2 = 1+INT(RANP(ISEED)/PUD)

C-- Store quark flavors in KID for now
         ITT=IABS(IFL1(JTB))-9
         KID(I1)=IQFLV(1,ITT)+16*IQFLV(2,ITT)+256*IFL2
         KID(I1)=ISIGN(KID(I1),IFL1(JTB))
         IFL1(JTB) = ISIGN(IFL2, -IFL1(JTB))
         JTB = 0
140   CONTINUE

C-- Form last or last two particles out of leftovers >>>>

C-- 2 if NQ=1, 2 or 4 if NQ=2 >>
150   JT = 2 + MIN(2*INT(NQ*RANP(ISEED)),2)
      DO 154 IQ=1,NQ
         JQ=IQ
         IF(IQ.EQ.2) JQ=3
         IF(JQ.EQ.JTB .OR. JT.EQ.JTB) GO TO 152

C-- Meson
         KID(ND-NQ+IQ)=6*IFL1(JQ) - IFL1(JT) -6
         GOTO 154

C-- Baryon
152      JTT = JT

C-- Assume JQ=JTB
         IF(JT.EQ.JTB) JTT = JQ
         ITT  = IABS(IFL1(JTB))-9
         IBAR = IQFLV(1,ITT)+16*IQFLV(2,ITT)+256*IABS(IFL1(JTT))
         KID(ND-NQ+IQ)=ISIGN(IBAR,IFL1(JTB))
         JTB  = 0
154      JT   = 6 - JT

C-- Now make real particles from the quark combinations
      PSUM=PSUMP
      DO 160 I1=NP+1,ND
         IF (IABS(KID(I1)).GE.256) GO TO 161

C-- Form mesons
         KID(I1) = KPART(KID(I1),IDUM)
         XM(I1)  = GETMAS(KID(I1))
         GOTO 160

C-- Form baryons from quark types stored in KID array
161      JSGN    = ISIGN(1,KID(I1))
         IBAR    = IABS(KID(I1))
         ITV(1,1)= IAND(IBAR,15)*JSGN
         ITV(1,2)= IAND(IBAR/16,15)*JSGN
         ITV(1,3)= IAND(IBAR/256,15)*JSGN
         KID(I1) = KBPART(ITV)
         XM(I1)  = GETMAS(KID(I1))

C-- Compute total mass
160      PSUM=PSUM+XM(I1)


C-- If rest masses too large, set error flag and return
      IF(PSUM.LT.CMAS)RETURN
      IF(ITRY.LT.NTRYMX) GOTO 70
      IERR=1

      RETURN
      END
