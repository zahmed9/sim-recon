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
*CMZ :  1.03/15 18/04/91  10.25.39  by  R.A.FULTON
*-- Author :    R.A.FULTON   27/12/90
      SUBROUTINE GGGFIN
C. Author    : R.A.FULTON  27/12/90  02.08.33
C
#include "qqlib/seq/qqluns.inc"
C
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'GGGFIN' )
C
C     Write out some statistics from two-photon generator
      CALL GGACUM( LOUTQQ )
      CALL GGREST
      CALL GGPRNT( LOUTQQ)
C
      RETURN
      END
