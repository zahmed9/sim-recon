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
*CMZ :  1.04/00 16/09/94  02.29.11  by  Paul Avery
*-- Author :    Lynn Garren   04/11/93
      SUBROUTINE QBPROP
C.......................................................................
C.
C. QBPROP - Initilization of variables.
C             (replaces  BLOCK DATA QQDATA)
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. COMMON    : QQPARS,QQPROP
C.
C. Calls     : none
C. Called    : QBINIT
C. Author    : Lynn Garren  04/11/93
C.
C. Detailed description
C.
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif
#include "seq/clinc/qqpars.inc"
#include "seq/clinc/qqprop.inc"

C=== LOCAL VARIABLES USED FOR DATA INPUT

      INTEGER I
      CHARACTER*4  XNAME(37)

C=== QQPROP

      DATA XNAME/ '*UU*','*UD*','*US*','*UC*','*UB*','*UT*',
     *            '*DU*','*DD*','*DS*','*DC*','*DB*','*DT*',
     *            '*SU*','*SD*','*SS*','*SC*','*SB*','*ST*',
     *            '*CU*','*CD*','*CS*','*CC*','*CB*','*CT*',
     *            '*BU*','*BD*','*BS*','*BC*','*BB*','*BT*',
     *            '*TU*','*TD*','*TS*','*TC*','*TB*','*TT*','*QQ*'/

C---------------------------------------------------------------------

C=== QQPROP /QQPARS/

      DO 60 I=1,37
60    QNAME(I) = XNAME(I)

      RETURN
      END
