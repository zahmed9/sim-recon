*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:14  eugenio
* Initial revision
*
* Revision 1.1.1.1  1995/08/01  17:59:54  nk
* Consolidation
*
* Revision 1.1.1.1  1994/10/04 21:54:51  zfiles
* first version of clutil in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.00/00 07/12/88  16.52.10  by  R. Namjoshi
*-- Author : R. Namjoshi
      SUBROUTINE ERRLUN( CRNAME, ILUN, IERR, CTEXT )
C.......................................................................
C.
C. ERRLUN - Error handler for the LUN manager
C.
C. Inputs    : CRNAME - Character name of calling routine
C.           : ILUN   - Unit number to which error applies
C.           : IERR   - Code indicating type of error
C.           : CTEXT  - Additional error specific text
C. Outputs   : None
C.
C. COMMON    : LUNMCI LUNMCC MESREP
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : LENOCC MESLOG NAMLUN REPLUN
C. Called    : CHKLUN FRELUN GETLUN LOKLUN
C.
C. Detailed description
C.  This routine gets called whenever an error condition is encountered
C.  in any of the LUNMGR routines. Depending on the error code, it
C.  constructs appropriate diagnostic message text, determines the
C.  correct severity of the error and calls MESLOG to log the message.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
      CHARACTER*(*) CRNAME, CTEXT
      INTEGER ILUN, IERR
* -------------------- EXTERNAL declarations ---------------
      INTEGER  LENOCC
      EXTERNAL LENOCC
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/lunmcde.inc"
#include "seq/clutil/mesrep.inc"
* -------------------- Local    declarations ---------------
      LOGICAL RCSINI
      CHARACTER*(*) CHRCSS, CHRCSR, CHRCST, CHRCSD, CHRCSA
      PARAMETER(CHRCSS='$RCSfile$')
      PARAMETER(CHRCSR='$Revision$')
      PARAMETER(CHRCST='$State$')
      PARAMETER(CHRCSD='$Date$')
      PARAMETER(CHRCSA='$Author$')
      CHARACTER*80 FNAME
      INTEGER I, NLEN
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
* None
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
* None
* ----------------- Executable code starts here ------------
#if WRITE_RCS_INFO
      IF(RCSINI)THEN
        RCSINI = .FALSE.
        CHMESS = '-------- CVSinfo --------'
        CALL MESLOG (CRNAME, 1, MSINFO)
        CHMESS = CHRCSS
        CALL MESLOG (CRNAME, 1, MSINFO)
        CHMESS = CHRCSR//' '//CHRCST
        CALL MESLOG (CRNAME, 1, MSINFO)
        CHMESS = CHRCSD//' '//CHRCSA
        CALL MESLOG (CRNAME, 1, MSINFO)
      ENDIF
#endif
C
C== Write message into CHMESS and call MESLOG
C
      IF(     IERR.EQ.LUSEER ) THEN
         NLEN = LENOCC(LUNOWN(ILUN))
         WRITE(CHMESS,10000) ILUN, LUNOWN(ILUN)(1:NLEN)
         CALL MESLOG(CRNAME,IERR,MSERRO)
      ELSEIF( IERR.EQ.LRNGER ) THEN
         WRITE(CHMESS,10010) ILUN
         CALL MESLOG(CRNAME,IERR,MSERRO)
      ELSEIF( IERR.EQ.LTABER ) THEN
         CALL REPLUN
         WRITE(CHMESS,10020)
         CALL MESLOG(CRNAME,IERR,MSABOR)
      ELSEIF( IERR.EQ.LFULER ) THEN
         CALL REPLUN
         WRITE(CHMESS,10030)
         CALL MESLOG(CRNAME,IERR,MSABOR)
      ELSEIF( IERR.EQ.LLOKER ) THEN
         NLEN = LENOCC(LUNOWN(ILUN))
         WRITE(CHMESS,10040) ILUN, LUNOWN(ILUN)(1:NLEN)
         CALL MESLOG(CRNAME,IERR,MSERRO)
      ELSEIF( IERR.EQ.LFLKER ) THEN
         NLEN = LENOCC(LUNOWN(ILUN))
         WRITE(CHMESS,10050) ILUN, LUNOWN(ILUN)(1:NLEN)
         CALL MESLOG(CRNAME,IERR,MSERRO)
      ELSEIF( IERR.EQ.LINIER ) THEN
         WRITE(CHMESS,10060) ILUN
         CALL MESLOG(CRNAME,IERR,MSABOR)
      ELSEIF( IERR.EQ.LUALER ) THEN
         CALL NAMLUN( ILUN, FNAME )
         IF( FNAME.EQ.' ' ) THEN
            WRITE(CHMESS,10070) ILUN
            CALL MESLOG(CRNAME,IERR,MSWARN)
         ELSE
            WRITE(CHMESS,10080) ILUN
            CALL MESLOG(CRNAME,IERR,MSWARN)
            WRITE(CHMESS,10090) FNAME
            CALL MESLOG(CRNAME,IERR,MSWARN)
         ENDIF
      ELSEIF( IERR.EQ.LDIFER ) THEN
         NLEN = LENOCC(LUNOWN(ILUN))
         WRITE(CHMESS,10100) ILUN, LUNOWN(ILUN)(1:NLEN), CTEXT(1:
     +   LENOCC(CTEXT))
         CALL MESLOG(CRNAME,IERR,MSWARN)
      ELSEIF( IERR.EQ.LNONAM ) THEN
         WRITE(CHMESS,10110) ILUN
         CALL MESLOG(CRNAME,IERR,MSWARN)
      ELSE
         WRITE(CHMESS,10120) IERR
         CALL MESLOG(CRNAME,IERR,MSWARN)
      ENDIF
C
      RETURN
C
10000 FORMAT(' LUN number', I3,
     +       ' is allocated by ', A, ' and cannot be locked' )
10010 FORMAT(' LUN number', I10, ' is out of range' )
10020 FORMAT(' LUN table has been corrupted' )
10030 FORMAT(' LUN table is full' )
10040 FORMAT(' LUN number', I3, ' is already locked by ', A )
10050 FORMAT(' LUN number', I3, ' is locked by ', A,
     +       ' it cannot be freed' )
10060 FORMAT(' Initialization failure' )
10070 FORMAT(' LUN number', I3,
     +       ' has unallocated connection to an unnamed file,',
     +       ' unit will be locked' )
10080 FORMAT(' LUN number', I3,
     +       ' has unallocated connection to the following file,',
     +       ' unit will be locked' )
10090 FORMAT(' File name: ', A )
10100 FORMAT(' LUN number', I3, ' allocated by ', A, ' deallocated',
     +       ' by ', A )
10110 FORMAT(' LUN number', I3, ' owner name is blank' )
10120 FORMAT(' Unknown error, IERR = ', I6 )
C
      END
