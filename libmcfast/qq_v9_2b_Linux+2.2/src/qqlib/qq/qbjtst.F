*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:43  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:27  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 16/09/94  02.29.22  by  Paul Avery
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBJTST
C.......................................................................
C.
C. QBJTST - Initilization of variables for JETSET.
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : JETSCL
C.
C. Calls     : LBINIT
C. Called    : QBINIT
C. Author    : Lynn Garren  04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "qqlib/seq/jetscl.inc"

C=== LOCAL VARIABLES USED FOR DATA INPUT

C---------------------------------------------------------------------

C=== JETSET COMMONS

C                           (replaces BLOCK DATA LUDATA)
      CALL LBINIT

C---  CLEO II default assignments

C                           Number of allowed quark flavors (qq=)
C                           MSTJ(104)
C                           (LUND Default = 5 : d,u,s,c,b)
C                           (CLEO Default = 4 : d,u,s,c  )
C
      NFLAV = 4

C                           Primary quark flavor to generate (qq=)
C                           (0 : mixture of all allowed flavors)
C                                d=1, u=2, s=3, c=4, b=5
C
C               *** Please note that definition of u and d quarks are
C                   reversed in JETSET versions 7.x from old versions 6.x
C
      IQTYPE = 0

C                           Initial state Radiative corrections
C                           MSTJ(107)
C                           (LUND Default = 0 : OFF)
C                           (CLEO Default = 1 : ON)
      ISTRAD = 1


C--  QCD corrections
C    MSTJ(101)
C    (LUND Default = 5 :  qq=  & parton shower)
C
C     *** Any change to this variable must be done in conjunction with the
C         parameters, a = PARJ(41) and b = PARJ(42), for the LUND string
C         fragmenatation function.
C
C       LUND default values of  MSTJ(101) = 5, a = 0.5, b = 0.9 works well.
C       2nd order QCD matrix correction of MSTJ(101) = 2, with a = 1.0 and
C       b = 0.7 also works fine at PEP/PETRA energy and at 10 GeV.
C
      QCDCOR = 5

C-- Choice of Longitudinal Fragmentation
C                                             MSTJ(11)
C
C       1 : LUND symmetric function
C       2 : different forms for each quark (FF or SLAC model)
C       3 : Hybrid (LUND symm. function for light quarks and
C                   SLAC(Peterson) for Heavy quarks)
C       4 : Mixture of LUND symmetric and Bowler string
C
C                      (LUND default = 1  : LUND symm.
C                       CLEO default = 1  : LUND symm.)

      LFRAG = 1
      LUNDAA = 0.4
      LUNDBB = 0.9

C ***   For SLAC (Peterson) function
C
C              epsilon (c) = (0.3/1.5)**2 = 0.04        PARJ(54)
C              epsilon (b) = (0.3/5.0)**2 = 0.004       PARJ(55)
C
C          Due to the QED and QCD corrections, the observed momentum distri-
C          bution will be softer than the shape with the above parameters.
C          Also note the MINUS sign!
C

      EPSC = -0.04
      EPSB = -0.004


C                           P/V/T ratio for Mesons
C                           (LUND Default)
C

      MSPIN(1) = 0.5
      MSPIN(2) = 0.6
      MSPIN(3) = 0.75
      MSPIN(4) = 0.05
      MSPIN(5) = 0.05
      MSPIN(6) = 0.05
      MSPIN(7) = 0.05



C                           Switch to turn off particle decay in LUND.
C                           Particles are decayed via QQ, using DECAY.DEC
C                                  0  :  OFF   -->  Decay in QQ
C                                  1  :  ON    -->  Decay in LUND

      LUNDEC = 0

C                           Switch to turn on/off of EDITing the particle
C                           list in LUND.  If ON, removes quarks, gluons,
C                           showers, and strings.  But not the decayed
C                           particles.  (See LUEDIT)
C                                  0  :  OFF   -->  NO EDIT
C                                  1  :  ON    -->  EDIT

      LXEDIT = 1

C                           Dump LUND event record
C                                  0 (OFF) ,  1 (ON)
      LNDDMP = 0


C                           Option to boost and rotate the ECM system
C                           using LUROBO.
C
C                           BSTECM(1) = theta    (polar coordinate)
C                           BSTECM(2) = phi      (polar coordinate)
C                           BSTECM(3) = px
C                           BSTECM(4) = py
C                           BSTECM(5) = pz
C                           BSTECM(6) :  0.0 = no boost,  1.0 = boost

      BSTECM(1) = 0.0
      BSTECM(2) = 0.0
      BSTECM(3) = 0.0
      BSTECM(4) = 0.0
      BSTECM(5) = 0.0
      BSTECM(6) = 0.0
C                           Minimum energy for partons where the fragmen-
C                           tation is stopped.

      EMINFX = 0.30

      RETURN
      END
