*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:39  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:38  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.49.22  by  Peter C Kim
*CMZ :  1.03/71 02/12/93  13.04.16  by  Lynn Garren
*CMZ :  1.03/70 12/10/93  16.54.14  by  Paul Avery
*CMZ :  1.03/35 06/12/91  15.27.08  by  Peter C Kim
*CMZ :  1.03/26 04/10/91  11.49.35  by  Peter C Kim
*CMZ :  1.03/17 24/07/91  16.51.09  by  Peter C Kim
*CMZ :  1.02/00 02/11/90  01.58.11  by  Paul Avery
*CMZ :  1.00/01 06/09/90  11.38.24  by  Paul Avery
*CMZ :  1.00/00 23/08/90  14.03.28  by  Paul Avery
*-- declare local variables, deflexify, adapt CLEO2 software standards
*CMZ :          20/05/90  13.38.51  by  Jorge L. Rodriguez
*CMZ :          19/05/90  15.07.54  by  Jorge L. Rodriguez
      SUBROUTINE QQINIT(LERROR)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Initialize QQ
C        NON-CLEO version
C
C   Vers. 1 1-05-82  Defined
C   Vers. 2 1-17-82  Allow particles to decay into jets
C   Vers. 3 4-8-82   Put in baryons and update DECAY.INP
C   Vers. 4 5-8-82   Put in finite width resonances
C   Vers. 5 6-10-82  Add include files QQ1.INC - QQ4.INC
C   Vers. 6 11-1-84  Flexified READDC, 16 bit bytes to store decay info,
C           TYPSCN in QQ main loop, character data everywhere,
C           new B decay model using WJET, use QQ.INC everywhere,
C           new particle list, vertex list.
C   Vers. 6.1  1-28-84  Check for batch if checking time, change free
C           format reads to fixed format for IBM (QQINIT and
C           READDC), move IER = 0 in NONLEP to beginning,
C           get rid of extra arrays in NONLEP, move data
C           statement for BQMAS to BLOCK DATA, fix bug for
C           continuum generation, fix KCODE in MODEVT.
C   Vers. 6.2  2-6-85   Put SPREAD in QQ.INC. EWIDTH was being set to 0.
C   Vers. 6.3  3-4-85   Change IRAN to ISEED in /RANDM/
C   Vers. 6.4  3-4-85   Add QED stuff from C. Rippich
C   Vers. 6.5  3-5-85   Change Sub. USER to USERXX in QQUSER.FLX; get
C           rid of variable BARYON.
C   Vers. 6.6  3-6-85   Set MOUT1=LOUT1 in QQINIT. Zero out IDECSV,
C           NDAUTV and IDAUTV for partons. Don't allow
C           partons in ISTBMC list.
C   Vers. 6.7  3-6-85   Get rid of extraneous return statement in MODINI.
C           Get rid of Commons /OUTDEV/, /OUT1/ and /OUT2/.
C           Move IOUT1=LOUT1 to first line in MODINI.
C           Replace (-1)**(I+1) by ISIGN(1,3-2*I) IN QCD.FLX
C   Vers. 6.8  3-7-85   Put ISELCT in main routine; get rid of IOUT in
C           QCDPAR; fix ANSI-77 problems.
C   Vers. 6.9  3-9-85   New QED routines from C. Rippich. I made them
C           ANSI compatible. I had to get DILOG and PIHINT
C           from the old program (I hope the're all right).
C   Vers. 6.10 3-13-85  Do not call ISELCT if LSELCT is False
C   Vers. 6.11  4-6-85  VAXIFICATION: SETRN1 puts QQ.CNT in SFD with
C                       world write protection on VAX, use READONLY for
C                       reading OLD files, use LOUT1=45 not 6.
C   Vers. 6.12  4-8-85  Put LUNTTI and LUNTTO in CLUNS.INC. Define ISEED
C                       for all machines. Add IRANQQ for each event.
C   Vers. 6.13  4-18-85 Put polarization in DECAY.INP files. Make sure
C                       that if MATRX > 0 for 2 body decays that the
C                       parent rest frame (not the lab frame) is used
C                       to define the coordinate system.
C   Vers. 6.14  5-3-85  Set ISEED = IRAN for VAX and IBM
C   Vers. 6.15  5-7-85  Add call to TYPINI.
C   Vers. 6.16  5-9-85  Fix IVPROD for partons in QCD events
C   Vers. 6.17  6-5-85  Changes regarding KMAX in QED031 and QQ
C   Vers. 6.18  6-11-85 Change ALOG(RAN to avoid zero value of RAN.
C                       Increase initial length of COMMON/CON1/ in BKQED
C   Vers. 6.19  6-19-85 Add IBM fixes a la Rohit N.
C   Vers. 6.20  7-03-85 Do more of same
C   Vers. 6.21  7-10-85 Fix EVTGEN to avoid infinite loops because of
C                       low CM energy.
C   Vers. 6.22  8-06-85 Changed TAUHAD so that electron-neutrino and
C                       tau-neutrino masses are not hard-wired to 0.
C   Vers. 6.23  8-09-85 Removed ascynchronous TYPSCN and used logical
C                       filenames for QQxxxx.DAT for 370E/IBM.
C   Vers. 6.24  9-18-85 Fixed SQRT(0 or NEG) in WJET
C   Vers. 6.25  9-20-85 Uncommented call to DECGEN(5) in GGGJET
C   Vers. 6.26 11-04-85 Now call READDC before EVOUT1 to get DECAY.INP on
C                       tape; removed unreachable RETURN in MODEVT
C   Vers. 6.27 12-04-85 SQRT(NEG) in QQJET protected against
C   Vers. 6.28  3-05-86 Avoid JT=1.+2.*RAN()=3 in WJET and QQJET
C   Vers. 6.29  3-24-86 Increase MPOLQQ from 50 to 100 in QQPARS.INC
C   Vers. 6.30  5-20-86 Graceful exit if time out in batch
C   Vers. 6.31  6-04-86 Avoid checking XSMIN(0) in EVTGEN
C   Vers. 6.32  7-11-86 Reduce values of BSIZE
C   Vers. 6.33  8-05-86 More arguments in call to HSTTTY
C   Vers. 6.34  8-11-86 SPECTR in QDECAY now uses ISEED, not IRAN
C   Vers. 6.35  9-03-86 GETPAR in QDECAY now sets IT=2 for charmed baryons
C   Vers. 6.36  3-20-87 NSLEFT.GT.0 for Florida
C   Vers. 6.37  2-09-88 write out BPOS and BSIZE to QQ record with ECM
C   Vers. 6.38  3-23-88 Implemented KEMAX for models 2-4
C   Vers. 6.39 10-25-88 Use Gaussian beam spot smearing, update parameters
C   Vers. 6.40 11-09-88 IDECSV modified for correct output to mass storage
C   Vers. 6.41 06-08-89 Smear in ECM modulated by resonanace if LRESPR
C   Vers. 7.00  7-25-90 Use new driver, new I/O format, new Commons
C   Vers. 7.01  9-01-90 Misc. bug fixes
C   Vers. 7.02  9-16-90 New version of MCCOMS, new I/O format, ROAR fields
C   Vers. 8.01  Feb, 91 Real New Version :
C   Vers. 9.01  Dec, 93 Make functional for non-CLEO users
C
C                       NAMELIST  -->  FFREAD
C                       BLOCK DATA QQDATA --> SUBROUTINE QBINIT
C                       Calls QQINPT for reading in QQ control parameters
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "qqlib/seq/qqluns.inc"

C-- Calling arguments
      LOGICAL LERROR

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      LERROR = .TRUE.

C     Version and event origin
      IVRSQQ = 902
      IORGQQ = 1
      WRITE(LTTOQQ,5002) IVRSQQ
5002  FORMAT(/,' QQ version: ',I5/)
C initialize CLEOG version number
      IVRSCG = 0

C Initialize Sigmas for beam dispersion in x and y directions

      BDSIGX = 0.0
      BDSIGY = 0.0

C
      CALL QQLBVR

C-- Set default parameters
      CALL QQIPAR

C-- Make cumulative list for SU(3) mixing (uu,dd,ss)
      CALL QQINIC

C-- Set random seed
      CALL QQIRND

C-- Read in default DECAY.DEC
      CALL QQRDCY(LERROR)
      IF(LERROR) GO TO 9999

C     Normal exit
      LERROR = .FALSE.
      RETURN

C     Error exit
9999  RETURN
      END
