*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:51  eugenio
* Initial revision
*
* Revision 1.3  1996/05/21 16:25:14  clib
* One more try at initializing IVRSQQ.
*
* Revision 1.2  1995/02/03  16:15:49  zfiles
* Mods from PCK. Call GTPIR and a few other routines after TRKSIM
* as options
*
* Revision 1.1  1994/10/19  23:29:13  zfiles
* user1-5 and usergn are combind into qquser.F
*
* Revision 1.1.1.1  1994/10/08  02:21:26  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 05/10/94  02.48.11  by  Peter C Kim
*CMZ :  1.01/01 06/11/90  13.32.18  by  Paul Avery
*CMZ :  1.01/00 09/09/90  00.13.11  by  Paul Avery
*CMZ :  1.00/01 06/09/90  11.38.24  by  Paul Avery
*CMZ :  1.00/00 23/08/90  14.03.28  by  Paul Avery
      SUBROUTINE USER1

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Initialize QQ stuff
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "qqlib/seq/qqluns.inc"

C-- Local variables
      LOGICAL LERROR
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Initialize variables (replaces the Block data QQDATA,
C                           plus other variables in LUND, KORALB.)
      CALL QBINIT

C     Initialize unit numbers from Driver
      CALL DVLUNS(LTTIQQ, LTTOQQ, LOUTQQ, LTMPQQ, LTINQQ, LTOUQQ)

C     Date and time from Driver
      CALL DVDATM(DATEQQ, TIMEQQ)

C     Get ID number to uniquely identify this process. Necessary for a
C     distributed job to ensure random numbers start from different seeds,
      CALL DVGUFM(IDQQ)

C     Initialize QQ
      CALL QQINIT(LERROR)
      IF(LERROR) STOP

C     Tell Driver how many events to analyze
      CALL DVSEMX(NDO)

C     Initialize user
      CALL ANAL1

      RETURN
      END

      SUBROUTINE USER2

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Begin run
C
C          Write BEGIN RUN RECORD.  (PCK 16/11/92)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
C
#include "seq/clinc/anlclev.inc"
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqevnt.inc"
#include "seq/clinc/qqbmst.inc"
#include "seq/clinc/qqbfld.inc"
#include "dvlib/seq/dvstatus.inc"
C
C     Local variables
      LOGICAL LWRIT
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Begin run
      CALL QQBGRN

C     Default is write the begin run header
      CALL DVSWRC(.TRUE.)

C     Call user BEGIN RUN
      CALL ANAL2

      IRUNDV = IRUNQQ
      IEVTDV = IEVTQQ

C     If writing on, put info for begin run
      CALL DVGWRC(LWRIT)
      IF(LWRIT) THEN
        DTYP = 4
        RUNN = IRUNQQ
        EVNT = IEVTQQ
        KLGL = 0
        ENRG = BEAMQQ
        BFIE = BFLDQQ

        CALL PTCLEV(.TRUE.,.FALSE.)
        CALL PTBEAM(.TRUE.)

        CALL PTMCPP
        CALL PTMCBR
      ENDIF


      RETURN
      END

      SUBROUTINE USER3
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Event
C
C        Allow TRKSIM capability at QQ level    (PCK 16/11/92)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqtrak.inc"
#include "qqlib/seq/qqcntl.inc"
#include "seq/clinc/qqinfo.inc"
#include "seq/clinc/anlccc.inc"
#include "seq/clinc/trkfc100.inc"

      CHARACTER*(*)  CRNAME
      PARAMETER( CRNAME = 'USER3' )

C     Local variables
      INTEGER I, NCH, IDAUCH(30), ITYPCH(30), IPNTCD(30)
      LOGICAL LWRIT, LERROR, LPROAR
      DATA LPROAR/.TRUE./
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C--- Initialize the ROAR field flags.

        CALL CLRWPK(-1,0,0,0,.FALSE.,0,0,0,CRNAME,0)

C-- Default is write the event
      CALL DVSWRC(.TRUE.)

C-- Fill up ANLCCD info for charged, stable tracks
C                                Disabled (PCK 16/11/92)
C      NCH = 30
C      CALL QQDAUC(0, NCH, IDAUCH)
C      DO 220 I=1,NCH
C        ITYPCH(I) = ITYPEV(IDAUCH(I),1)
C220   CONTINUE
C      NTRKCD = 0
C      IF(NCH .GT. 0) THEN
C        CALL FTQQ2C(NCH, IDAUCH, ITYPCH, IPNTCD, LERROR)
C      ENDIF

C--- Call TRKSIM
C       Added options for pi0, V0, and Eid.             PCK 1/19/95 
C       Defaults are:     ON   ON      OFF   (qbcntl.F)

      IF(LTRKSM) THEN
        CALL TRKSIM
        CALL GLBFIL
        IF(LTSMP0) CALL GTPIR
        IF(LTSMVF) CALL VFINDR
        IF(LTSMEI) CALL GETEID
      ENDIF

C     Call user EVENT
      CALL ANAL3

C     If writing is on, fill ROAR
      CALL DVGWRC(LWRIT)
      IF(LWRIT) THEN
        IF(LTRKSM) THEN
          CALL UCOPY( ENRSH(1), ENUSH(1), NSHOWR)
          CALL UCOPY( THESH(1), THUSH(1), NSHOWR)
          CALL WRCLR
          CALL PTCLEV(.TRUE.,.TRUE.)
          CALL PTTGRG(.TRUE.)
          CALL PTGLAN(.TRUE.)
          CALL PTTRKF(.TRUE.)
          CALL PTTRAK(.TRUE.)
          CALL PTVRTX(.TRUE.)
          CALL PTCCSH(.TRUE.,.FALSE.)
          CALL PTTRSH(.TRUE.)
          CALL PTXBAL(.TRUE.)
          CALL PTMUTR(.TRUE.)
          CALL PTMURR(.TRUE.)
          CALL PTTFID(.TRUE.)
          CALL PTTFDT(.TRUE.)
          CALL PTTFRW(.TRUE.)
          CALL PTTF2G(.TRUE.)
          CALL PTDEDR(.TRUE.)
          IF(LTSMP0) CALL PTCCP0(.TRUE.)
          IF(LTSMEI) CALL PTR2EL(.TRUE.)
          CALL PTMCOM
          CALL PTTGTK(.TRUE.)
          CALL PTTGCC(.TRUE.)
        ELSE
          CALL PTMCOM
        ENDIF
      ENDIF

      RETURN
      END

      SUBROUTINE USER5

#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Finish QQ processing
C  ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL QQFINI

C     User summary
      CALL ANAL5

      RETURN
      END

      SUBROUTINE USERGN(IRUN, IEVT, ISTAT)

C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Generate QQ event
C
C *IRUN      Integer variable (write)
C            Run number
C
C *IEVT      Integer variable (write)
C            Event number
C
C *ISTAT     Integer variable (write)
C             = 1 Begin run record
C             = 2 Event record
C             = 3 End run record
C             = 4 Header record
C             = 5 EOF
C             = 6 End of dataset
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

C-- Calling arguments
      INTEGER IRUN, IEVT, ISTAT
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      CALL QQGENR(IRUN, IEVT, ISTAT)

      RETURN
      END
