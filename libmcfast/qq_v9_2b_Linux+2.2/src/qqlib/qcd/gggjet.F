*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.10.45  by  Paul Avery
*CMZ :  1.02/00 22/09/90  10.31.43  by  Paul Avery
*CMZ :  1.00/00 10/06/90  20.23.54  by  Jorge L. Rodriguez
*-- Author :
* 15/10/96 Lynn Garren:  Add double precision conditionals.
      SUBROUTINE GGGJET(ECM,X1,X2)
C.......................................................................
C.
C. GGGJET -
C.
C. Inputs    :
C. Outputs   :
C.
C. COMMON    : QQPROP MCGEN
C.
C. Calls     : DECGEN PTDIST QQJET ROTBST
C. Called    : GGGGEN
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

*- Argument declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION ECM, X1, X2
#else
      REAL ECM, X1, X2
#endif

*- External declarations
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION GETMAS, ZDIST
      REAL     RANP
#else
      REAL     GETMAS, ZDIST, RANP
#endif
      INTEGER  KPART, KBPART
      EXTERNAL GETMAS, ZDIST, KPART, KBPART, RANP
*
*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"

      INTEGER NJ, NQJ
      INTEGER ISEED
      COMMON / GCM / NJ(3), NQJ(3)
      COMMON /RANDM/ISEED
*
*- Local declarations
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'GGGJET' )
*
      INTEGER ITV(2,3)
      INTEGER IFLQ(6)
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION THEG(3),SA(3),CA(3),W(3,2),PX(6),PY(6),Z(6,2),
     +        QMTS(6),GAMM(6)
#else
      REAL    THEG(3),SA(3),CA(3),W(3,2),PX(6),PY(6),Z(6,2),
     +        QMTS(6),GAMM(6)
#endif

      INTEGER KEV, ITRY, IC, JS, JR, ITRY2, J1, J2, IFL1, IFLB1
      INTEGER JSGN, ITT, JT, IFLB2
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION HA, HB, HC, HD, HE
      DOUBLE PRECISION WR1, WR2, WRS, WMIN, PTP, PLP
#else
      REAL    HA, HB, HC, HD, HE
      REAL    WR1, WR2, WRS, WMIN, PTP, PLP
#endif

C-- IBAR=.TRUE. means a baryon has been produced
      LOGICAL INIT, IBAR

      SAVE    INIT
      SAVE    KEV
      DATA    INIT / .TRUE. /
*
*- Executable code starts here
*
*
      IF ( INIT ) KEV = 0
      INIT = .FALSE.
      KEV = KEV + 1

C-- Initial values, two-gluon and three-gluon events

 1001 ITRY = 0
      DO 100 IC=1,3

C-- KC(I) is the ident. no. of the jet, there are 13 no.s-
C-- 1 GLUON + 6 QUARKS +6 ANTI-QUARKS

         KC(IC)=0
         NJ(IC) = 0

C-- PC is the 4-momenta of a jet

         PC(IC,1)=0.
  100    PC(IC,2)=0.

C-- If the energy frac. of the most energetic jet is too close
C-- to 1., make this a 2-jet event

#if defined(NONCLEO_DOUBLE)
      IF(DMAX1(X1,X2,2.-X1-X2).GT.1.-(7.*PAR(9)/ECM)**2) GOTO 114
#else
      IF(AMAX1(X1,X2,2.-X1-X2).GT.1.-(7.*PAR(9)/ECM)**2) GOTO 114
#endif

C-- Following addition put in oct. 15,1982

#if defined(NONCLEO_DOUBLE)
      IF(DMIN1(X1,X2,2.-X1-X2).LT..4) GO TO 114
#else
      IF(AMIN1(X1,X2,2.-X1-X2).LT..4) GO TO 114
#endif
      GO TO 111

C-- PAR(9) is the avg. transverse mass for hadrons

114   NC=2
      DO 110 IC=1,2
         PC(IC,3)=0.5*ECM*SIGN(1.,1.5-IC)
CPA      PC(IC,3)=0.5*ECM*(-1.)**(IC+1)
  110    PC(IC,4)=0.5*ECM

      GOTO 112

  111 NC=3

C-- Here we calculate the 4-mom. of the jets; note that the
C-- first jet is defined as having no ptransverse, the 3 jets
C-- lie in a plane- later we rotate and boost into the lab

      PC(1,4)=0.5*X1*ECM
      PC(2,4)=0.5*X2*ECM
      PC(3,4)=0.5*(2.-X1-X2)*ECM
      PC(1,3)=PC(1,4)
      PC(2,3)=(PC(3,4)**2-PC(2,4)**2-PC(1,4)**2)/(2.*PC(1,4))
      PC(2,1)=SQRT(PC(2,4)**2-PC(2,3)**2)
      PC(3,3)=-PC(1,3)-PC(2,3)
      PC(3,1)=-PC(1,1)-PC(2,1)

  112 CONTINUE

C-- Small systems generated with phase space only

      IF(IST.LT.0) RETURN

C-- If too little c.m. energy is left, just decay this

      IF(ECM.GE.7.*PAR(9)) GOTO 113
      AMASS(5)=ECM
      CALL DECGEN(5)
      RETURN

  113 CONTINUE

C-- Loop over number of jets(nc) ; js is jet index
C-- angles and energies for jet systems
      DO 120 JS=1,NC
         JR=JS+1
         IF(JS.EQ.NC) JR=1
         THEG(JS)=SIGN(ACOS(PC(JS,3)/PC(JS,4)),PC(JS,1))
         CA(JS)=SQRT(0.5*(1.-(PC(JS,1)*PC(JR,1)+PC(JS,3)*PC(JR,3))/
     +          (PC(JS,4)*PC(JR,4))))
         SA(JS)=SQRT(1.-CA(JS)**2)
         W(JS,1)=PC(JS,4)*CA(JS)
  120    W(JS,2)=PC(JR,4)*CA(JS)

C-- IBAR=.TRUE. means that a baryon has been produced

      IBAR = .FALSE.

 130  CONTINUE
      ITRY2 = 0
      ITRY = ITRY + 1

C--Only try 30 times to produce a baryon
      IBAR = ITRY .GT. 30

C-- Form mesons at gluon corners. generate pt and z+
C-- JS is index for one gluon jet, JR for one of the neighboring
C-- jets; do each pair   J1 and J2 are the 'string-leg' indices

      DO 160 JS=1,NC
         JR=JS-1
         IF(JS.EQ.1) JR=NC
         J1=2*JR
         J2=2*JS-1

C--     also add baryon generator at the gluon corner.
C--            H. KOOY, SYRACUSE U., 21-JAN-81
C--     only allow one diquark per gluon

 138     CONTINUE

C--          use large wbar to supress baryon prod. in qqjet
C
C        FLIP=40.*(WBAR/PC(JS,4))**4
C        FLIP=AMAX1(FLIP,.5)
C
         IF ( FLIP .LT. RANP(ISEED) .OR. IBAR .OR.
     *        PC(JS, 4) .LT. WBAR  ) GO TO 131

C--          create leading baryon for this gluon
C--          one per event
         IBAR = .TRUE.

C--          diqflv returns a diquark flavor index of 1-6
         CALL DIQFLV ( IFL1 )

C--          a flavor g.t. 10 siginifies a di-quark
         IFLB1 = IFL1 + 9

C--          IFLB2 is the flavor of the quark to be combined with the
C--          diquark to form the baryon, u,d,s = 1,2,3
         IFLB2 = 1 + INT ( RANP(ISEED) / PUD )

C--          now make the baryon from the quark and di-quark
         JSGN=ISIGN(1,IFLB1)
         ITT=IFL1
         ITV(1,1)=IQFLV(1,ITT)*JSGN
         ITV(1,2)=IQFLV(2,ITT)*JSGN
         ITV(1,3)=IFLB2*JSGN
         K(LASTN+JS, 1) = KBRFLV( IFL1, IFLB2)

C--        K(LASTN+JS,2) is the particle ident. no.,PS1 tell whether
C--        a vector or pseudo-scalar particle will be formed
         K(LASTN+JS, 2) = KBPART(ITV)

C--        give equal probability for baryon or antibaryon at corner
         IF ( RANP(ISEED) .GT. 0.5 ) GO TO 136
         IFLQ(J2) = IFLB1
         IFLQ(J1) = IFLB2
         GO TO 134

 136     IFLQ(J1) = - IFLB1
         IFLQ(J2) = - IFLB2

C--        anti-particle id. no. is 1 + particle id. no.
         K(LASTN+JS, 2) = K(LASTN+JS, 2) + 1
         GO TO 134

C--        create leading meson of this gluon
C--        IFLQ1 is the id. no. of the quark,
C--        IFLQ(J2) is the id. no. of the anti-quark

 131     IFLQ(J1)=1+INT(RANP(ISEED)/PUD)
         IFLQ(J2)=-(1+INT(RANP(ISEED)/PUD))
         K(LASTN+JS,1)=6*MAX0(IFLQ(J1),IFLQ(J2))-MIN0(IFLQ(J1),
     +               IFLQ(J2))-6
         K(LASTN+JS,2)=KPART(K(LASTN+JS,1),INT(PS1+RANP(ISEED)))

 134     P(LASTN+JS,5)=GETMAS(K(LASTN+JS,2))
         IF ( IBAR .AND. P(LASTN+JS, 5) .GT. PC(JS, 4) * 0.4 )
     +      GO TO 138

 140     CONTINUE
         ITRY2 = ITRY2 + 1
         IF ( ITRY2 .GT. 50 ) GO TO 130

         CALL PTDIST(PX(J1),PY(J1),SIGMA)
         CALL PTDIST(PX(J2),PY(J2),SIGMA)

         Z(J1,2)=ZDIST(IFLQ(J1),0.,1.)
         Z(J2,1)=ZDIST(IFLQ(J2),0.,1.)

C--        Choose z- components along hyperbola

         HA=(Z(J1,2)*W(JR,2)+Z(J2,1)*W(JS,1)*CA(JR)/CA(JS)+2.
     +    *PX(J2)*CA(JR)*(SA(JR)/CA(JR)+SA(JS)/
     +        CA(JS)))*W(JR,1)
         HB=(Z(J2,1)*W(JS,1)+Z(J1,2)*W(JR,2)*CA(JS)/CA(JR)+
     +     2.*PX(J1)*CA(JS)*(SA(JR)/CA(JR)+SA(JS)
     +         /CA(JS)))*W(JS,2)
         HC=CA(JR)*CA(JS)*(SA(JR)/CA(JR)+SA(JS)/CA(JS))**2
     +      *W(JR,1)*W(JS,2)
         HD=P(JS,5)**2+(PX(J1)-PX(J2))**2+(PY(J1)+PY(J2))**2

C--        if the z values lie outside the z limits choose another z
         IF(HA.LE.HD .OR. HB.LE.HD) GOTO 140
         HE=(HA*HB+HC*HD)**2

  150    Z(J1,1)=RANP(ISEED)*HD/HA
         Z(J2,2)=(HD-HA*Z(J1,1))/(HB+HC*Z(J1,1))

C--       kinematic contstraint on jets
         IF(1.+HE/(HB+HC*Z(J1,1))**4.LT.(1.+HE/HB**4)
     *         *RANP(ISEED)**2)           GOTO 150

C-- weighting in gamma for IFR=2. reject if remaining systems too small
C-- the following is the lund model suppression factor for q-qbar
C-- pairs produced with a finite spatial sepatial seperation

         IF(IFR.NE.2) GOTO 151
         QMTS(J1)=(QMAS(IABS(IFLQ(J1)))-QMAS(7))**2+PX(J1)**
     +          2+PY(J1)**2
         GAMM(J1)=(1.-Z(J1,2))*Z(J1,1)*W(JR,1)*W(JR,2)
         QMTS(J2)=(QMAS(IABS(IFLQ(J2)))-QMAS(7))**2+PX(J2)**
     +          2+PY(J2)**2
         GAMM(J2)=(1.-Z(J2,1))*Z(J2,2)*W(JS,1)*W(JS,2)
         IF(GAMM(J1)/(QMTS(J1)+GAMM(J1))*GAMM(J2)/(QMTS(J2)+
     +          GAMM(J2)).LT. RANP(ISEED)) GOTO 140

  151    CONTINUE

  160 CONTINUE

      DO 170 JS=1,NC
         WR1=(1.-Z(2*JS-1,1)-Z(2*JS,1))*W(JS,1)
         WR2=(1.-Z(2*JS-1,2)-Z(2*JS,2))*W(JS,2)
         WRS=WR1*WR2-(PX(2*JS-1)+PX(2*JS))**2-(PY(2*JS-1)+PY(2*JS))**2
         WMIN=QMAS(IABS(IFLQ(2*JS-1)))+QMAS(IABS(IFLQ(2*JS)))+PAR(9)

C-- Add to min. w needed if a baryon if being produced
         IBAR=IABS(IFLQ(2*JS-1)).GE.10 .OR. IABS(IFLQ(2*JS)).GE.10
         IF(IBAR) WMIN=WMIN+PAR(9)
C
C************* CHANGE MAY 19,1981 CABENDA &GILCHRIESE
C    CHANGED BACK OCT 8,1982 -- MESTAYER
C      WMIN=QMAS(IABS(IFLQ(2*JS-1)))+QMAS(IABS(IFLQ(2*JS)))

  170    IF(WR1.LE.0..OR.WRS.LE.WMIN**2) GOTO 130

C-- four-momentum for particles at corners
      DO 180 JS=1,NC
         NJ(JS) = 1
         JR=JS-1+NC*((NC+1-JS)/NC)
         J1=2*JR
         J2=2*JS-1
         P(LASTN+JS,2)=PY(J1)+PY(J2)
         P(LASTN+JS,4)=(0.5*Z(J1,2)*W(JR,2)+0.5*Z(J1,1)*
     +     W(JR,1)+PX(J1)*SA(JR))/CA(JR)+(0.5*Z(J2,1)*
     +      W(JS,1)+0.5*Z(J2,2)*W(JS,2)+PX(J2)*SA(JS))/
     +       CA(JS)
         PTP=PX(J2)+Z(J2,2)*W(JS,2)*SA(JS)-PX(J1)-Z(J1,1)*
     +   W(JR,1)*SA(JR)
         PLP=P(LASTN+JS,4)-Z(J1,1)*W(JR,1)*CA(JR)-Z(J2,2)*
     +   W(JS,2)*CA(JS)
         P(LASTN+JS,1)=COS(THEG(JS))*PTP+SIN(THEG(JS))*PLP
  180    P(LASTN+JS,3)=COS(THEG(JS))*PLP-SIN(THEG(JS))*PTP

C      N=NC
C-- start where we left off
      N=LASTN+NC

C-- Call QQJET for treatment of remaining systems
      IST=IST+1
      DO 200 JS=1,NC
         K(250,2)=N
         DO 190 JT=1,2

C-- Here we load the flavor, pperp, and w of the unpaired quarks in
C-- preparation for the call to QQJET
         K(248+JT,1)=-IFLQ(2*JS-2+JT)
         P(248+JT,1)=-PX(2*JS-2+JT)
         P(248+JT,2)=-PY(2*JS-2+JT)
         P(248+JT,3)=(1.-Z(2*JS-1,JT)-Z(2*JS,JT))*W(JS,JT)
         P(248+JT,4)=(1.-Z(2*JS-2+JT,JT))*W(JS,JT)
  190    P(248+JT,5)=GAMM(2*JS-2+JT)

C-- Call QQJET for each of the q-qbar sub-systems
      CALL QQJET(0,0.)
      NJ(JS) = NJ(JS) + NQJ(1) + NQJ(2)

#if defined(NONCLEO_DOUBLE)
      CALL ROTBST(0.D0,0.D0,SA(JS),0.D0,0.D0)
  200 CALL ROTBST(THEG(JS)-ASIN(SA(JS)),0.D0,0.D0,0.D0,0.D0)
#else
      CALL ROTBST(0.,0.,SA(JS),0.,0.)
  200 CALL ROTBST(THEG(JS)-ASIN(SA(JS)),0.,0.,0.,0.)
#endif

      IST=IST-1
C     IF(IST.EQ.0) CALL DECAYS

      RETURN
      END
