*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:29  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:06  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  2.00/00 17/11/94  10.26.17  by  Alan J. Weinstein
*CMZ :  2.00/00 21/01/93  15.43.09  by  Alan Weinstein
*-- Author :
CDECK  ID>, PHOKIN.
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE PHOKIN(IP,NCHARG)
C.----------------------------------------------------------------------
C.
C.    PHOTOS:   PHOton radiation in  decays reconstruction of KINematics
C.
C.    Purpose:  Starting  from   the  charged  particle energy/momentum,
C.              PNEUTR, photon  energy  fraction and photon  angle  with
C.              respect  to  the axis formed by charged particle energy/
C.              momentum  vector  and PNEUTR, scale the energy/momentum,
C.              keeping the original direction of the neutral system  in
C.              the lab. frame untouched.
C.
C.    Input Parameters:   IP:      Pointer  to   decaying  particle   in
C.                                 /HEPEVT/  and   the   common   itself
C.                        NCHARG:  Element  of the array CHAPOI  contai-
C.                                 ning pointer to the charged radiating
C.                                 daughter in /HEPEVT/.
C.
C.    Output Parameters:  Common /HEPEVT/, with photon added.
C.
C.    Author(s):  Z. Was, B. van Eijk             Created at:  26/11/89
C.                                                Last Update: 21/12/92
C.
C.----------------------------------------------------------------------
      IMPLICIT NONE
      DOUBLE PRECISION PHOAN1,PHOAN2,ANGLE,FI1,FI3,FI4,FI5,TH1,TH3,TH4
      DOUBLE PRECISION BET(3),PB,GAM,PARNE,QNEW,QOLD,DATA
      INTEGER IP,FI3DUM,NCHARG,I,II,J,K,NEUDAU,FIRST,LAST
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION EPHOTO,PMAVIR,PHOTRI
      REAL GNEUT,PHORAN
      DOUBLE PRECISION CCOSTH,SSINTH,PVEC(4),PBOOST(5)
#else
      REAL EPHOTO,PMAVIR,PHOTRI
      REAL GNEUT,PHORAN,CCOSTH,SSINTH,PVEC(4),PBOOST(5)
#endif
#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/hepevt.inc"
C     INTEGER NMXHEP
C     PARAMETER (NMXHEP=2000)
C     INTEGER IDHEP,ISTHEP,JDAHEP,JMOHEP,NEVHEP,NHEP
C     REAL PHEP,VHEP
C     COMMON/HEPEVT/NEVHEP,NHEP,ISTHEP(NMXHEP),IDHEP(NMXHEP),
C    &JMOHEP(2,NMXHEP),JDAHEP(2,NMXHEP),PHEP(5,NMXHEP),VHEP(4,NMXHEP)
      INTEGER PDMMAX
      PARAMETER (PDMMAX=100)
      INTEGER CHAPOI
      DOUBLE PRECISION MCHSQR,MNESQR
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION PNEUTR
#else
      REAL PNEUTR
#endif
      COMMON/PHOMOM/MCHSQR,MNESQR,PNEUTR(5),CHAPOI(PDMMAX)
      DOUBLE PRECISION COSTHG,SINTHG
      REAL XPHCUT,XPHMAX,XPHOTO
      COMMON/PHOPHD/COSTHG,SINTHG
      COMMON/PHOPHS/XPHCUT,XPHMAX,XPHOTO
      REAL PI,TWOPI
      COMMON/PHPICO/PI,TWOPI
      LOGICAL BOOST
      BOOST=.FALSE.
C--
C--   Check whether parent is in its rest frame...
      IF (ABS(PHEP(4,IP)-PHEP(5,IP))/PHEP(5,IP).GT.1.E-8) THEN
        BOOST=.TRUE.
C--
C--   Boost daughter particles to rest frame of parent...
C--   Resultant neutral system already calculated in rest frame !
        DO 10 J=1,3
   10   BET(J)=-PHEP(J,IP)/PHEP(5,IP)
        GAM=PHEP(4,IP)/PHEP(5,IP)
        DO 30 I=JDAHEP(1,IP),JDAHEP(2,IP)
          PB=BET(1)*PHEP(1,I)+BET(2)*PHEP(2,I)+BET(3)*PHEP(3,I)
          DO 20 J=1,3
   20     PHEP(J,I)=PHEP(J,I)+BET(J)*(PHEP(4,I)+PB/(GAM+1.))
   30   PHEP(4,I)=GAM*PHEP(4,I)+PB
      ENDIF
      EPHOTO=XPHOTO*PHEP(5,IP)/2.
      PMAVIR=SQRT(PHEP(5,IP)*(PHEP(5,IP)-2.*EPHOTO))
C--
C--   Find pointer to the first component of 'neutral' system
      DO 40 I=JDAHEP(1,IP),JDAHEP(2,IP)
        IF (I.NE.CHAPOI(NCHARG)) THEN
          NEUDAU=I
          GOTO 50
        ENDIF
   40 CONTINUE
C--
C--   Pointer not found...
      DATA=NCHARG
      CALL PHOERR(5,'PHOKIN',DATA)
C--
C--   Reconstruct  kinematics  of  charged particle  and  neutral system
   50 FI1=PHOAN1(PNEUTR(1),PNEUTR(2))
C--
C--   Choose axis along  z of  PNEUTR, calculate  angle  between x and y
C--   components  and z  and x-y plane and  perform Lorentz transform...
      TH1=PHOAN2(PNEUTR(3),SQRT(PNEUTR(1)**2+PNEUTR(2)**2))
      CALL PHORO3(-FI1,PNEUTR(1))
      CALL PHORO2(-TH1,PNEUTR(1))
C--
C--   Take  away  photon energy from charged particle and PNEUTR !  Thus
C--   the onshell charged particle  decays into virtual charged particle
C--   and photon.  The virtual charged  particle mass becomes:
C--   SQRT(PHEP(5,IP)*(PHEP(5,IP)-2*EPHOTO)).  Construct  new PNEUTR mo-
C--   mentum in the rest frame of the parent:
C--   1) Scaling parameters...
      QNEW=PHOTRI(PMAVIR,PNEUTR(5),PHEP(5,CHAPOI(NCHARG)))
      QOLD=PNEUTR(3)
      GNEUT=(QNEW**2+QOLD**2+MNESQR)/(QNEW*QOLD+SQRT((QNEW**2+MNESQR)*
     &(QOLD**2+MNESQR)))
      IF (GNEUT.LT.1.) THEN
        DATA=0.
        CALL PHOERR(4,'PHOKIN',DATA)
      ENDIF
      PARNE=GNEUT-SQRT(MAX(GNEUT**2-1.0,0.))
C--
C--   2) ...reductive boost...
      CALL PHOBO3(PARNE,PNEUTR)
C--
C--   ...calculate photon energy in the reduced system...
      NHEP=NHEP+1
      PHEP(4,NHEP)=EPHOTO*PHEP(5,IP)/PMAVIR
C--
C--   ...and photon momenta
      CCOSTH=-COSTHG
      SSINTH=SINTHG
      TH3=PHOAN2(CCOSTH,SSINTH)
      FI3=TWOPI*PHORAN(FI3DUM)
      PHEP(1,NHEP)=PHEP(4,NHEP)*SINTHG*COS(FI3)
      PHEP(2,NHEP)=PHEP(4,NHEP)*SINTHG*SIN(FI3)
C--
C--   Minus sign because axis opposite direction of charged particle !
      PHEP(3,NHEP)=-PHEP(4,NHEP)*COSTHG
      PHEP(5,NHEP)=0.
C--
C--   Rotate in order to get photon along z-axis
      CALL PHORO3(-FI3,PNEUTR(1))
      CALL PHORO3(-FI3,PHEP(1,NHEP))
      CALL PHORO2(-TH3,PNEUTR(1))
      CALL PHORO2(-TH3,PHEP(1,NHEP))
      ANGLE=EPHOTO/PHEP(4,NHEP)
C--
C--   Boost to the rest frame of decaying particle
      CALL PHOBO3(ANGLE,PNEUTR(1))
      CALL PHOBO3(ANGLE,PHEP(1,NHEP))
C--
C--   Back in the parent rest frame but PNEUTR not yet oriented !
      FI4=PHOAN1(PNEUTR(1),PNEUTR(2))
      TH4=PHOAN2(PNEUTR(3),SQRT(PNEUTR(1)**2+PNEUTR(2)**2))
      CALL PHORO3(FI4,PNEUTR(1))
      CALL PHORO3(FI4,PHEP(1,NHEP))
C--
C--   See whether neutral system has multiplicity larger than 1...
      IF ((JDAHEP(2,IP)-JDAHEP(1,IP)).GT.1) THEN
        DO 60 I=2,4
   60   PVEC(I)=0.
        PVEC(1)=1.
        CALL PHORO3(-FI3,PVEC)
        CALL PHORO2(-TH3,PVEC)
        CALL PHOBO3(ANGLE,PVEC)
        CALL PHORO3(FI4,PVEC)
        CALL PHORO2(-TH4,PNEUTR)
        CALL PHORO2(-TH4,PHEP(1,NHEP))
        CALL PHORO2(-TH4,PVEC)
        FI5=PHOAN1(PVEC(1),PVEC(2))
C--
C--   Charged particle restores original direction
        CALL PHORO3(-FI5,PNEUTR)
        CALL PHORO3(-FI5,PHEP(1,NHEP))
        CALL PHORO2(TH1,PNEUTR(1))
        CALL PHORO2(TH1,PHEP(1,NHEP))
        CALL PHORO3(FI1,PNEUTR)
        CALL PHORO3(FI1,PHEP(1,NHEP))
C--
C--   Find pointers to components of 'neutral' system
        FIRST=NEUDAU
        LAST=JDAHEP(2,IP)
        DO 70 I=FIRST,LAST
          IF (I.NE.CHAPOI(NCHARG).AND.(JMOHEP(1,I).EQ.IP)) THEN
C--
C--   Reconstruct kinematics...
            CALL PHORO3(-FI1,PHEP(1,I))
            CALL PHORO2(-TH1,PHEP(1,I))
C--
C--   ...reductive boost
            CALL PHOBO3(PARNE,PHEP(1,I))
C--
C--   Rotate in order to get photon along z-axis
            CALL PHORO3(-FI3,PHEP(1,I))
            CALL PHORO2(-TH3,PHEP(1,I))
C--
C--   Boost to the rest frame of decaying particle
            CALL PHOBO3(ANGLE,PHEP(1,I))
C--
C--   Back in the parent rest-frame but PNEUTR not yet oriented.
            CALL PHORO3(FI4,PHEP(1,I))
            CALL PHORO2(-TH4,PHEP(1,I))
C--
C--   Charged particle restores original direction
            CALL PHORO3(-FI5,PHEP(1,I))
            CALL PHORO2(TH1,PHEP(1,I))
            CALL PHORO3(FI1,PHEP(1,I))
          ENDIF
   70   CONTINUE
      ELSE
C--
C--   ...only one 'neutral' particle in addition to photon!
        CALL PHORO2(TH1-TH4,PNEUTR(1))
        CALL PHORO2(TH1-TH4,PHEP(1,NHEP))
        CALL PHORO3(FI1,PNEUTR(1))
        CALL PHORO3(FI1,PHEP(1,NHEP))
        DO 80 J=1,4
   80   PHEP(J,NEUDAU)=PNEUTR(J)
      ENDIF
C--
C--   All 'neutrals' treated, fill /HEPEVT/ for charged particle...
      DO 90 J=1,3
   90 PHEP(J,CHAPOI(NCHARG))=-(PHEP(J,NHEP)+PNEUTR(J))
      PHEP(4,CHAPOI(NCHARG))=PHEP(5,IP)-(PHEP(4,NHEP)+PNEUTR(4))
C--
C--   When parent was not in its rest-frame, boost back...
      IF (BOOST) THEN
        DO 110 J=JDAHEP(1,IP),JDAHEP(2,IP)
          PB=-BET(1)*PHEP(1,J)-BET(2)*PHEP(2,J)-BET(3)*PHEP(3,J)
          DO 100 K=1,3
  100     PHEP(K,J)=PHEP(K,J)-BET(K)*(PHEP(4,J)+PB/(GAM+1.))
  110   PHEP(4,J)=GAM*PHEP(4,J)+PB
C--
C--   ...boost photon
        PB=-BET(1)*PHEP(1,NHEP)-BET(2)*PHEP(2,NHEP)-BET(3)*PHEP(3,NHEP)
        DO 120 K=1,3
  120   PHEP(K,NHEP)=PHEP(K,NHEP)-BET(K)*(PHEP(4,NHEP)+PB/(GAM+1.))
        PHEP(4,NHEP)=GAM*PHEP(4,NHEP)+PB
        BOOST=.FALSE.
      ENDIF
C--
C--   Photon mother and daughter pointers !
      JMOHEP(1,NHEP)=IP
      JMOHEP(2,NHEP)=0
      JDAHEP(1,NHEP)=0
      JDAHEP(2,NHEP)=0
C--
C--   Modify momentum/energy for cascade decays
      DO 150 I=JDAHEP(1,IP),JDAHEP(2,IP)
        IF (JDAHEP(1,I).NE.0) THEN
C--
C--   Reconstruct original energy/momentum of daughter
          DO 130 J=1,5
  130     PBOOST(J)=0.
          FIRST=JDAHEP(1,I)
          LAST=JDAHEP(2,I)
          DO 140 K=FIRST,LAST
            DO 140 J=1,4
  140     PBOOST(J)=PBOOST(J)+PHEP(J,K)
          PBOOST(5)=PHEP(5,I)
C--
C--   Correct energy/momentum of cascade daughters
          IF (JMOHEP(1,I).EQ.IP) THEN
            II=I
            CALL PHOBOS(II,PBOOST,PHEP(1,I),FIRST,LAST)
          ENDIF
        ENDIF
  150 CONTINUE
      END
