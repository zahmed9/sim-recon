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
*CMZ :  1.00/00 17/11/88  15.21.09  by  R. Namjoshi
*-- Author : R. Namjoshi
      SUBROUTINE INILUN
C.......................................................................
C.
C. INILUN - Initialize the LUN manager
C.
C. Inputs    : None
C. Outputs   : None
C.
C. COMMON    : LUNMCC LUNMCI
C. Banks D   : None
C. Banks L   : None
C. Banks M   : None
C. Banks U   : None
C.
C. Calls     : None
C. Called    : FRELUN GETLUN LOKLUN QRYLUN REPLUN <USER>
C.
C. Detailed description
C.  This routine initializes the LUN manager. It marks all units as
C.  being free and clears the owner table. It is called automatically
C.  by FRELUN GETLUN LOKLUN QRYLUN REPLUN. Subsequent calls to INILUN
C.  are ignored.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
* -------------------- Argument declarations ---------------
* None
* -------------------- EXTERNAL declarations ---------------
* None
* -------------------- SEQUENCE declarations ---------------
#include "cleoks/cluseq/lunmcde.inc"
* -------------------- Local    declarations ---------------
      LOGICAL RCSINI
      CHARACTER*(*) CHRCSS, CHRCSR, CHRCST, CHRCSD, CHRCSA
      PARAMETER(CHRCSS='$RCSfile$')
      PARAMETER(CHRCSR='$Revision$')
      PARAMETER(CHRCST='$State$')
      PARAMETER(CHRCSD='$Date$')
      PARAMETER(CHRCSA='$Author$')
      LOGICAL LFIRST
      INTEGER I
* -------------------- SAVE     declarations ---------------
      SAVE RCSINI
      SAVE LFIRST
* -------------------- DATA  initializations ---------------
      DATA RCSINI/.TRUE./
      DATA LFIRST /.TRUE./
* ----------------- Executable code starts here ------------
#if WRITE_RCS_INFO
      IF(RCSINI)THEN
        RCSINI = .FALSE.
        WRITE(6,*)'-------- CVSinfo --------'
        WRITE(6,*)CHRCSS
        WRITE(6,*)CHRCSR//' '//CHRCST
        WRITE(6,*)CHRCSD//' '//CHRCSA
      ENDIF
#endif
C
      IF( LFIRST ) THEN
         LFIRST = .FALSE.
         DO 10 I = LUNMIN, LUNMAX
            LUNTBL(I) = LISFRE
            LUNOWN(I) = ' '
10       CONTINUE
      ENDIF
C
      RETURN
      END
