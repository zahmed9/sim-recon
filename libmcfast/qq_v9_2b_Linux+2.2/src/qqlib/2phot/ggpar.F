*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:33  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:35  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.23.18  by  Paul Avery
*CMZ :  1.03/15 24/05/91  09.58.04  by  R.A.FULTON
*-- Author :
      SUBROUTINE GGPAR(NLU)
C         MC commands are set up.
C   AUTHOR/DATE:   T. Jensen Aug. '90
C   based on original routines BLKDAT, CLEAR, PARAM
C   by  John R. Smith  October 1987.

#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/fragmt.inc"
#include "qqlib/gggseq/ggramp.inc"
#include "qqlib/gggseq/ggcombo.inc"
#include "qqlib/seq/ggginp.inc"
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "seq/clinc/qqevnt.inc"
#include "qqlib/seq/jetscl.inc"
#include "geant/gcdes/ludat1.inc"
#include "qqlib/seq/ludat2.inc"
#include "geant/gcdes/ludat3.inc"


        INTEGER   IC, MST1, MST7, MST8, MST9
        INTEGER   MSTE1, MSTE2, MSTE4, MSTE5, MSTE6, MSTE7
        INTEGER   MSTE30, MSTE35, NLU
        INTEGER   KFTEMP, KCTEMP(8)
        REAL      ANGTMP, PAR1, PAR2, PAR8, PAR12
        REAL      PAR23, PAR24, PAR31, PAR32
        REAL      PARE1, PARE2, PARE60
        REAL      WMIN, WMAX

C  EXTERNALS::
        INTEGER   LUCOMP, LQPMAT
        EXTERNAL  LUCOMP, LQPMAT

      MODE2G = MODLGG
      NTAG2G = NTAGGG
C        Convert QQ particle ID to LUND KF code
      KFRES  = LQPMAT( KRESGG, 2 )
      JRES2G = JRESGG
      ELEC2G = ELONLY
      IF(JRESGG .EQ. -99)THEN
         JRES2G = SPIN(KRESGG)
      ELSE
         JRES2G = JRESGG
      ENDIF
      IF(JPARGG .EQ. -99)THEN
         JPAR2G = LPARTY(KRESGG)
      ELSE
         JPAR2G = JPARGG
      ENDIF
      LHRS2G = LHRSGG
      LUMTL  = LMTLGG
      F2TYPE = F2TPGG
      SIG0   = SIG0GG
      EPAMAX = EPAGG
      WMIN   = WMINGG
      WMAX   = WMAXGG
      TAGMN  = TG1LGG
      TAGMX  = TG1HGG
      DBTGMN = TG2LGG
      DBTGMX = TG2HGG
      ANGUNT = ANGUGG
      EXPSL  = EXPSGG
      PTBRK  = PTBRGG
      GVDM   = GVDMGG
      RHOPOL = RHOPGG
      NUMQRK = NQRKGG
      IQRK   = IQRKGG
      TARGMS = TRGMGG
      DOFRAG = .FALSE.
      IF(LUNDEC .EQ. 1)DOFRAG = .TRUE.

      PTSLPE = 8.0

      NEPAUP = 0
      NSTPSD = 100
      FACT2G = 7.037E-4
      TRY2G  = 0.
      OK2G   = 0.
      GGAREA = 0.

C  set default and initial values for a number of parameters
      COS2GX = 0.999
      IRES2G = 1111
      WMRS2G = 0.
      BWMG2G = 5.


      QMN    = 0.175
      QMX    = 0.325
      PTMIN  = 0.250
      PTMAX  = 0.375
      XMNN   = 0.8
      XMX    = 8.0
C

      DO 5 IC=1,3
        COMBS(IC)  = 0
        EVTYPE(IC) = .FALSE.
    5 CONTINUE

C********************************************************
C
      NORAMP = .TRUE.
      LMSBSQ = 0.2**2
      EPS1 = 0.0
      EPS2 = 0.0
      EPS3 = 0.0
      EPS4 = 0.0
      EPS5 = 0.0
      EPS6 = 0.0
      EPS7 = 0.0
C
C... GET MAXIMUM (E+E- CMS) ANGLE FOR UNTAGGED ELECTRON
      T1MIN  = TAGMX
      T3MIN  = TAGMX
      T2MAX  = 0.0
      T3MAX  = 0.0
      XSMIN  = 0.0
      XSMAX  = 1.0
      EPAUPS = 0.0
C
C
      MST1   = 0
      MST7   = 1
      MST8   = 1
      MST9   = 0

C     PAR1   =  0.1
      PAR1   =  0.0414
C     PAR2   =  0.3
      PAR2   =  0.202
      PAR8   =  0.5
C     PAR12  =  0.4
      PAR12  =  0.375
C     PAR23  =  1.1
      PAR23  =  0.8
      PAR24  =  1.5
      PAR31  =  1.0
      PAR32  =  0.7

      MSTE1  = 2
      MSTE2  = 2
      MSTE4  = 5
      MSTE5  = 1
      MSTE6  = 1
      MSTE7  = 0
      MSTE30 = 3
      MSTE35 = 1

C     PARE1  = 1.5
      PARE1  = 0.2
C     PARE2  = 0.5
      PARE2  = 0.2
      PARE60 = 0.5

      WMAX   = AMIN1(WMAX,ECM)
      WMN2G  = WMIN**2
      WMX2G  = WMAX**2
      X2G0   = 818.596
      X2G1   = 0.0

C...SPECIAL CASES
C...SECTION TO PRINTOUT THE USERS MODEL.
      WRITE(6,8000) MODE2G
8000  FORMAT(22X,'***TWOGAM 2.0 - TWO PHOTON EVENT GENERATOR***'//
     +           20X,'FINAL STATE PRODUCTION MODEL #',I4)
      PRINT *,' E+E- CENTER OF MASS ENERGY (GEV) =',ECM
      IF(DOFRAG)PRINT *,' REQUESTING EVENT FRAGMENTATION VIA LUND'
      IF(TARGMS)PRINT *,' REQUESTING TARGET MASS EFFECTS'
      PRINT *,' SIGMA VDM GAMMA-GAMMA (NBS) = ',SIG0
C
      IF(F2TYPE.EQ.4)THEN
      MSTE1  = 0
      ENDIF
      IF(F2TYPE.GE.6)THEN
        IF(PTBRK.LT.2.0)THEN
          PRINT *,' PTBRK set too low for this model '
          PTBRK = MAX(PTBRK,2.0)
          PRINT *,' PTBRK Reset to higher value: PTBRK =',PTBRK
        ENDIF
      ENDIF

C  set values for lund particle decay scheme

      PARJ(1)   = PAR1
      PARJ(2)   = PAR2
      PARJ(11)  = PAR8
      PARJ(21)  = PAR12
      PARJ(33)  = PAR23
      PARJ(34)  = PAR24
      PARJ(41)  = PAR31
      PARJ(42)  = PAR32

      PARJ(121) = PARE1
      PARJ(122) = PARE2
      PARJ(160) = PARE60

      MSTU(1)   = MST1
      MSTJ(21)  = MST7
      MSTJ(24)  = MST8
      MSTU(10)  = MST9

      MSTJ(101) = MSTE1
      MSTJ(102) = MSTE2
      MSTJ(104) = MSTE4
      MSTJ(105) = MSTE5
      MSTJ(106) = MSTE6
      MSTJ(107) = MSTE7
      MSTJ(115) = MSTE30
      MSTJ(120) = MSTE35

C     Turn off LUND decays of selected particles
C      pi0
      KCTEMP(1) = LUCOMP(111)
C      eta
      KCTEMP(2) = LUCOMP(221)
C      k_s0
      KCTEMP(3) = LUCOMP(310)
C      sigma-
      KCTEMP(4) = LUCOMP(3112)
C      sigma+
      KCTEMP(5) = LUCOMP(3222)
C      lambda0
      KCTEMP(6) = LUCOMP(3122)
C      xi-
      KCTEMP(7) = LUCOMP(3312)
C      xi0
      KCTEMP(8) = LUCOMP(3322)
C
      DO 100 IC = 1,8
 100  MDCY(KCTEMP(IC),1) = 0
      RETURN
      END
