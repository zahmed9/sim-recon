*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:28  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/11/22  16:57:01  zfiles
* first version of korb in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/05 17/11/94  10.05.44  by  Alan J. Weinstein
*CMZ :  1.03/05 15/04/91  18.41.10  by  Peter C Kim
*-- Author :    Alan Weinstein  23/12/90
* 15/10/96 Lynn Garren: Add double precision conditionals.
      SUBROUTINE DECAKS(LBOOST)
C.......................................................................
C.
C. DECAKS - Fill QQ common from /JETS/.
C.
C. Inputs    : LBOOST - true to boost particles from cms to lab frame
C.           :
C. Outputs   : None
C.
C. COMMON    :
C.
C. Calls     : KORALB(0), RBOOSF, RANP, VZERO
C. Called    : by MODUSR, at present.
C. Author    : Alan Weinstein 23/12/90
C.
C. Detailed description
C.   A rewrite of DECADD in QQ to take particles in /JETS/,
C.   fill MCCOMS, generating vertices and decaying undecayed tracks
C.   as you go. The KS array tells us if a track has been decayed,
C.   and if not, which mode to decay it as.
C.   Loop over tracks in /JETS/, fill MCCOMS; generate vertices.
C.......................................................................
*SELF,IF=TYPECHEK.
      IMPLICIT NONE
*SELF.
* -------------------- Argument declarations ---------------
*
      LOGICAL LBOOST
* -------------------- EXTERNAL declarations ---------------
*
* -------------------- SEQUENCE declarations ---------------
* MC info
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqvrtx.inc"
#include "qqlib/seq/qqbrat.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqmxcp.inc"
*
* -------------------- Local    declarations ---------------
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'DECAKS' )
*
* Functions:
      REAL RANP
 
* Decay flag common
* KS (indexed as in /JET/),
*    = 0 for undecayed particles (QQ will decay if unstable)
*    = 1 for decayed particles (QQ will not decay it)
*    < 0 -pointer into MLLIST (QQ will decay with this mode)
      INTEGER KS
      COMMON/DECKS/KS(250)
*
      INTEGER IPAR,ITYP,L,IV,IPD,IP
#if defined(NONCLEO_DOUBLE)
      DOUBLE PRECISION R,FACT
#else
      REAL R,FACT
#endif
 
* -------------------- SAVE     declarations ---------------
*
* -------------------- DATA  initializations ---------------
*
* ----------------- Executable code starts here ------------
 
C get particles from /JETS/ into MCCOMS; boosting, generating
C   vertices, and decaying undecayed particles as we go.
      NTRKQQ = 0
      IPD = 0
  300 IF (IPD.GE.N) GOTO 999
      IPD = IPD+1
C
C Add this particle to the QQ list.
      NTRKQQ = NTRKQQ+1
      ITYP = K(IPD,2)
      ITYPEV(NTRKQQ,1) = ITYP
C add cms 4-vector, and boost to lab cms
      DO 240 L=1,4
         P4QQ(L,NTRKQQ) = P(IPD,L)
  240 CONTINUE
      IF (LBOOST) THEN
#if defined(NONCLEO_DOUBLE)
        CALL DBOOSF(P4CMQQ, 1, P4QQ(1,NTRKQQ), P4QQ(1,NTRKQQ))
#else
        CALL RBOOSF(P4CMQQ, 1, P4QQ(1,NTRKQQ), P4QQ(1,NTRKQQ))
#endif
      END IF
C
C Is track from primary vertex, or secondary?
      IPAR = -K(IPD,1)
      IPRNTV(NTRKQQ) = IPAR
      IVPROD(NTRKQQ) = 1
      IF (IPAR.GT.0) THEN
        IVPROD(NTRKQQ) = IVDECA(IPAR)
C update NDAUTV of parent.
        NDAUTV(IPAR) = NDAUTV(IPAR)+1
        IF(IDAUTV(IPAR).EQ.0) IDAUTV(IPAR) = NTRKQQ
      END IF
 
C update NTRKOU of in-vertex.
      IV = IVPROD(NTRKQQ)
      NTRKOU(IV) = NTRKOU(IV) + 1
      IF(ITRKOU(IV).EQ.0) ITRKOU(IV) = NTRKQQ
 
C initialize NTAUTV of particle.
      NDAUTV(NTRKQQ) = 0
      IDAUTV(NTRKQQ) = 0
C
C Does this track need to be decayed by QQ?
      IF (KS(IPD).LE.0 .AND. IPLIST(1,ITYP).GT.0) THEN
C If KS<0, it has decay mode pointer, tell QQ
        ILDECA(NTRKQQ) = 0
        IF (KS(IPD).LT.0) ILDECA(NTRKQQ)=-KS(IPD)
C Have QQ decay it.
        CALL QQDECA(IPD,N,KS(IPD))
      END IF
C
C Is track stable? (radiated photon has KS=10000)
      IF (KS(IPD).LE.0) THEN
C no decay, no decay vertex.
        IVDECA(NTRKQQ) = 0
        IDECSV(NTRKQQ) = 0
      ELSE
C-- Make new decay vertex. IV is the production vertex of this particle
        NVRTX = NVRTX + 1
        IVDECA(NTRKQQ) = NVRTX
        IDECSV(NTRKQQ) = KS(IPD)
        ITRKIN(NVRTX) = NTRKQQ
        NTRKOU(NVRTX) = 0
        ITRKOU(NVRTX) = 0
        IVKODE(NVRTX) = 1
 
C-- Generate lifetime/mass
        R = RANP(0)
#if defined(NONCLEO_DOUBLE)
        FACT = -CTAU(ITYP)/AMASS(ITYP)*DLOG(MAX(R,1.D-4))
#else
        FACT = -CTAU(ITYP)/AMASS(ITYP)*ALOG(MAX(R,1.E-4))
#endif
C Would like to swim the decay vertex, but KoralB has already decayed.
C I think that this is the only kludge...
        XVTX(NVRTX,1) = XVTX(IV,1) + FACT * P4QQ(1,NTRKQQ)
        XVTX(NVRTX,2) = XVTX(IV,2) + FACT * P4QQ(2,NTRKQQ)
        XVTX(NVRTX,3) = XVTX(IV,3) + FACT * P4QQ(3,NTRKQQ)
        TVTX(NVRTX) = TVTX(IV) + FACT * P4QQ(4,NTRKQQ)/2.998E-4
        RVTX(NVRTX) = SQRT(XVTX(NVRTX,1)**2 + XVTX(NVRTX,2)**2)
      END IF
 
C pick up next particle in /JETS/ common
      GOTO 300
 
  999 N = 0
 
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
