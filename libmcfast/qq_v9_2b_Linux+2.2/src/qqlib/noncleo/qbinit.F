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
*CMZ :  1.04/00 17/04/94  20.47.32  by  Lynn Garren
*CMZ :  1.03/71 06/12/93  14.33.17  by  Lynn Garren
*CMZ :  1.03/68 30/08/93  10.59.33  by  Peter C Kim
*CMZ :  1.03/57 15/02/93  14.56.17  by  Peter C Kim
*CMZ :  1.03/52 16/11/92  21.22.06  by  Unknown
*CMZ :  1.03/49 21/09/92  14.05.55  by  Peter C Kim
*CMZ :  1.03/45 27/04/92  15.51.54  by  Peter C Kim
*CMZ :  1.03/36 16/12/91  19.47.25  by  Peter C Kim
*CMZ :  1.03/25 01/10/91  10.08.32  by  Peter C Kim
*CMZ :  1.03/22 18/09/91  17.35.55  by  Peter C Kim
*CMZ :  1.03/15 18/07/91  16.29.52  by  Peter C Kim
*CMZ :  1.03/11 21/06/91  13.47.45  by  Peter C Kim
*CMZ :  1.03/00 27/03/91  17.43.22  by  Peter C Kim
*CMZ :  1.02/00 30/01/91  15.56.52  by  Peter C Kim
*-- Author :    Peter C Kim   30/01/91
      SUBROUTINE QBINIT
C.......................................................................
C.
C. QBINIT - Initilization of variables.
C             (replaces  BLOCK DATA QQDATA)
C.
C. Inputs    : NONE
C. Outputs   : NONE
C.
C. Called    : driver
C. Author    : Peter C Kim  30/01/91  15.37.48
C.
C.    NONCLEO version            LAG 12/2/93
C.......................................................................
#if defined(CLEO_TYPECHEK)
      IMPLICIT NONE
#endif

      CHARACTER*(*) CRNAME
      PARAMETER(    CRNAME = 'QBINIT' )

C---------------------------------------------------------------------

C=== blank file names
      CALL QBFILE

C=== QQBFLD
      CALL QBBFLD

C=== QQSPCM /SPECOM/  for Subroutine SPECTR
      CALL QBSPCM

C=== QQWJET /WWJET/  for Subroutine WJET
      CALL QBWJET

C=== QQPROP
      CALL QBPROP

C=== QQCNTL
      CALL QBCNTL

C=== MCJET
      CALL QBMCJT

C=== MCGEN
      CALL QBMCGN

      RETURN
      END
