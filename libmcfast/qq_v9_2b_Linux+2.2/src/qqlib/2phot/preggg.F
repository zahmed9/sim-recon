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
*CMZ :  1.03/15 24/05/91  09.56.39  by  R.A.FULTON
*-- Author :    R.A.FULTON   11/03/91
      SUBROUTINE PREGGG
C.......................................................................
C. PREGGG -  initalize values that could be updated by QQINPT
C.......................................................................
*
#include "qqlib/seq/ggginp.inc"
      REAL        PI
      PARAMETER( PI = 3.1415927 )
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'PREGGG' )
*
C  set default and initial values for a number of parameters
      MODLGG = 0
      NTAGGG = 2
      KRESGG = 0
      JRESGG = -99
      JPARGG = -99
      LHRSGG = -99
      F2TPGG = 7
      SIG0GG = 300.
      EPAGG  = 0.0
      WMINGG = 0.1
      WMAXGG = 10000.0
      TG1LGG = 0.0
      TG1HGG = PI
      TG2LGG = 0.0
      TG2HGG = PI
      ANGUGG = 0.0
      EXPSGG = 0.339
      PTBRGG = 2.0
      GVDMGG = .TRUE.
      RHOPGG = .FALSE.
      NQRKGG = 4
      IQRKGG = 1
      TRGMGG = .TRUE.
      LMTLGG = .TRUE.
      ELONLY = .FALSE.
      RETURN
      END
