*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.26.17  by  Paul Avery
*CMZ :  1.03/74 07/01/94  15.47.26  by  Brian Heltsley
* take out nonsensical limit on photon energy for mupairs
*CMZ :  1.03/62 23/03/93  16.12.26  by  Brian Heltsley
* put in FPAIR (mumuggg)
*CMZ :          16/11/92  15.59.51  by  Unknown
*CMZ :  1.03/49 21/09/92  17.46.07  by  Peter C Kim
*CMZ :  1.03/31 22/11/91  13.07.30  by  B. Heltsley
* put in BHLUMI: "new" bhahba generator
*CMZ :          01/10/91  10.10.30  by  Peter C Kim
*CMZ :  1.02/00 21/08/90  21.08.21  by  Paul Avery
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
*>> Author :
      SUBROUTINE MODINI
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Initializes the models
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqbmst.inc"
#include "qqlib/seq/mcgen.inc"
#include "qqlib/seq/qqluns.inc"
*
C-- External declarations

C-- Local variables
       INTEGER          ISOFT,IWEAK,INCL
       REAL             XKMIN,XKMAX,XKMUMX
       DOUBLE PRECISION DKMIN,DKMAX,DANGMN,DANGMX,DBEAM,DMAS

C-- Additional internal common blocks.

C-- In SEQ/MCGEN  use N,K(,),P(,) = OUTPUT
      INTEGER   IMODDD, IOUT
      COMMON/QED000/IMODDD,IOUT
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C-- output device for qed routines
      IOUT = LTTOQQ

      IF (MODEL.LT.0 .OR. MODEL.GT.5) GOTO 100

C-- all qed stuff...models 2,3,4,5
C     fixup 3-23-88: maximum photon energy is now kemax.
C     upper limit of 1.-5*(mu/e) is imposed for mu pair model.
C
C-- convention...1,2,3,4
      IMODDD = MODEL-1

      XKMIN  = KEMIN
      XKMAX  = KEMAX
      XKMUMX = 1. - 5.*AMASS(11)/(ECM/2.)
Cnonsense bkh      IF (MODEL .EQ. 3) XKMAX = MIN(KEMAX,XKMUMX)

C QEDXX1(BEAM,VARIOUS ARGUMENTS....)       INITIALIZATION
C QEDXX2(QP,QM,PH)                         GENERATE 4-VECTORS
C QEDXX3                                   FINAL PRINTOUT..X-SECTIONS
C QEDXX4(K0,KMAX)                          IF YOU FEEL LIKE CHANGING K0
C
C ALL ARGUMENTS DOUBLE PRECISION.....QP(4),QM(4),PH(4)
C
C XX=01 E+E-
C    02 MU+MU-
C    03 TAU+TAU-
C    04 GAMA,GAMA
C
C FOR INITIALIZATION, THE VARIOUS ARGUMENTS ARE IN PRINCIPLE:
C     ANGMIN,ANGMAX,XKMIN,XKMAX (PLUS OTHERS LISTED BELOW)
C
C XX=01...XKMAX=1.0 ALLOWED
C
C XX=02...XKMAX MUST BE.LT.1.0
C XX=02...IGNORE ANGMAX, USE 180-ANGMIN
C      ...THERE EXISTS A VARIABLE I WILL CALL 'LOGICAL' FOR NOW
C      ...   EFFECT ON EVENTS WITH K<K0 ("SOFT PHOTONS"):
C      ...   IF FALSE: PHOTON GETS ZERO ENERGY, LEPTONS ARE BACK-TO-BACK
C      ...   IF TRUE: SUBROUTINE FIXFOT GENERATES NON-ZERO PHOTON.
C      ...   COMMUNICATION: IF IMODE=0 THEN LOGICAL=.FALSE.
C      ...                  IF  .NE.0  ..............TRUE.
C      ...    ALSO: IWEAK=0 DONT DO WEAK INTERACTIONS
C      ...              .NE.0   YES, DO THEM.
C      ...    COMMUNICATION:
C      ...      USE THE '100' DIGIT OF IMODE TO SPECIFY IWEAK.
C
C XX=03...ANGMAX,XKMIN,XKMAX IGNORED...FULL FASESPACE GENERATED
C      ...USE IMODE TO SPECIFY MS,INCL FOR:
C                       CALL QED031(DBLE(BEAMQQ),MS,INCL)
C      ...MS = IABS(IMODE)/1000.
C      ...INCL=0 IF IMODE.LT.0, =1 IF IMODE.GT.0
C      ...MS IS THE MASS OF THE OUTGOING LEPTON PAIR
C      ... (E.G. MUONS OR TAUS)
C      ...INCL=1 IF YOU WANT TO ADD 'MS' INTO THE VACUUMPOLARIZATION
C      ... THE DEFAULT VAC.POL. INCLUDES:
C      ...         ELEC.,MUONS,TAUS,HADRONS
C      ... THUS, IF YOU SPECIFY E.G. IMODE=-107, THEN YOU SHOULD
C      ...     GET RESULTS VERY CLOSE TO BKMUON GENERATOR.
C>>>>>>FIXUP 5.JUNE.85>>>>>>>>>>
C      ... INCLUDE XKMAX AS EXTRA PARAMETER
C          IF=0., USE DEFAULT VALUES (KMAX=1-(M/E)**2 FOR FINAL STATES,
C                       AND KMAX=1-0.5MEV/E FOR INIT.RAD.)
C          OTHERWISE, USE MIN(DEFAULT,XKMAX)
C->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
C XX=04 ... ANGMAX,XKMIN,XKMAX IGNORED.
C XX=04 ... NOTE THAT THE 3-GAMA MODEL PERMUTES THE 3 GAMAS
C            RANDOMLY BY DEFAULT.
C          ANGMIN APPLIES TO THE 2 MOST ENERGETIC PHOTONS IN THAT CASE
C>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C-- Set double precision variables
      DBEAM  = BEAMQQ
      DANGMN = ANGMIN
      DANGMX = ANGMAX
      DKMIN  = XKMIN
      DKMAX  = XKMAX

C-- K < K0 ==> no photon
      ISOFT  = 0

C-- do weak interactions
      IWEAK = 1

C-- tau mass
      DMAS = AMASS(15)

C-- don't add anything to vac. pol.
      INCL = 0

C-- initialize the various qed models
      IF     (MODEL .EQ. 2) THEN
        CALL QED011(DBEAM,DANGMN,DANGMX,DKMIN,DKMAX)
      ELSEIF (MODEL .EQ. 3) THEN
        CALL QED021(DBEAM,DANGMN,DKMIN,DKMAX,ISOFT,IWEAK)
      ELSEIF (MODEL .EQ. 4) THEN
        CALL QED031(DBEAM,DANGMN,DMAS,0,DKMAX)
      ELSEIF (MODEL .EQ. 5) THEN
        CALL QED041(DBEAM,DANGMN)
      ENDIF

      IF(BMRAD) CALL QED031(DBEAM, 0.D0, 0.D0, 0, DKMAX)

 100  CONTINUE

      IF(MODEL.LT.0) THEN
        WRITE(LTTOQQ,900)
        GOTO 1000
      ENDIF


      IF    (MODEL.EQ.6) THEN
                                 CALL GGGINI
                                 GOTO 1000
      ELSEIF(MODEL.EQ.7) THEN
                                 CALL KORBBR
                                 GOTO 1000
      ELSEIF(MODEL.EQ.8) THEN
                                 CALL BHLUBJ
                                 GOTO 1000

      ELSEIF(MODEL.EQ.9) THEN
                                 CALL FPARBJ
                                 GOTO 1000

      ELSEIF(MODEL.GE.11 .AND. MODEL.LE.20) THEN
                                 CALL QILUND
                                 GOTO 1000
      ELSEIF(MODEL.EQ.10)  THEN
                                 CALL MODINU
                                 GOTO 1000
      ELSEIF(MODEL.NE.31) THEN
C              WRITE(LTTOQQ,900)
C              GOTO 1000
      ENDIF

900   FORMAT(1X,'MODINI: UNDEFINED MODEL ')

1000  RETURN
      END
