*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:40  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:31  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.04/00 22/09/94  00.11.14  by  Paul Avery
*CMZ :  1.02/00 05/06/90  15.41.34  by  Jorge L. Rodriguez
*-- Author :
      SUBROUTINE TMASS(TM)
C.......................................................................
C.
C. TMASS -
C.
C. Inputs    : TM
C.
C. COMMON    : QQPROP MCGEN
C.
C. Called    :
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
*- Argument declarations
      REAL TM
*
*- Sequence declarations
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"
#include "qqlib/seq/mcgen.inc"
*
*- Local declarations
*
      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'TMASS' )
*
      INTEGER J
*
*- Executable code starts here
*
C-- Change top quark mass to TM (GEV) with resulting meson mass changes
      QMAS(6)=TM
      DO 100 J=1,5
         AMASS(39+2*J)=TM+QMAS(J)-0.03
         AMASS(40+2*J)=TM+QMAS(J)-0.03
         AMASS(79+2*J)=TM+QMAS(J)+0.01
  100    AMASS(80+2*J)=TM+QMAS(J)+0.01
      AMASS(56)=2.*TM-1.03
      AMASS(96)=2.*TM-0.99

      RETURN
      END
