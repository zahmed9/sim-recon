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
*CMZ :  1.03/20 11/08/91  15.16.03  by  R.A.FULTON
*-- Author :
      SUBROUTINE GGACUM(UNIT1)
C*****************************************************
C COMPUTE CROSS SECTION AND PROGRAM EFFICIENCY.
C****************************************************

#include "qqlib/gggseq/ggprms.inc"
#include "qqlib/gggseq/ggmodl.inc"
#include "qqlib/gggseq/sintag.inc"
#include "qqlib/gggseq/wgtsum.inc"

      INTEGER    UNIT1
      REAL       LUMIN, ELUM, D1TMP, D2TMP, EFF, EFF1, EFFPC
      REAL       ERR, ERR1, FSUM, SDEVW, SIG, SIG1
      DOUBLE PRECISION   OK2GT,TRY2GT,WSTMP,W2STMP
C
      DATA OK2GT,TRY2GT,WSTMP,W2STMP /0.0D+00,0.0D+00,0.0D+00,0.0D+00/
C
      SIG   = 0.
      EFF   = 0.
      SIG1  = 0.
      EFF1  = 0.
      IF(TRY2G .GT. 0.1)THEN
         EFF   = OK2G/TRY2G
         EFFPC = 100.*EFF
         IF (NTAG2G .EQ. 0) THEN
           SIG = 2.0*FACT2G*GGAREA*EPAMAX*DTAG*EFF
         ELSE IF (NTAG2G .EQ. 1) THEN
           SIG = 2.0*FACT2G*GGAREA*EPAMAX*D2GTH*DTAG*EFF
         ELSE IF (NTAG2G .EQ. 2) THEN
           D1TMP = D1GTH/2.0
           D2TMP = D2GTH/2.0
           SIG = 2.0*FACT2G*GGAREA*EPAMAX*D1TMP*D2TMP*EFF
         ELSE
           WRITE (UNIT1,*) ' ERROR IN GGACUM: NTAG2G = ',NTAG2G
         ENDIF
         ERR  = SIG*SQRT((1.-EFF)/(EFF*TRY2G))

         FSUM = SNGL(WSUM)/TRY2G
         IF (NTAG2G .EQ. 0) THEN
           SIG1=2.*FACT2G*GGAREA*DTAG*FSUM
         ELSE IF (NTAG2G .EQ. 1) THEN
           SIG1=2.*FACT2G*GGAREA*D2GTH*DTAG*FSUM
         ELSE IF (NTAG2G .EQ. 2) THEN
           D1TMP = D1GTH/2.
           D2TMP = D2GTH/2.
           SIG1=2.*FACT2G*GGAREA*D1TMP*D2TMP*FSUM
         ELSE
           WRITE (UNIT1,*) ' ERROR IN GGACUM: NTAG2G = ',NTAG2G
         ENDIF
         IF(WSUM.NE.0.)THEN

           ERR1 = SNGL(WSUMSQ/WSUM**2) - 1./TRY2G
           IF(ERR1.LE.0.0) ERR1 = 0.0
           ERR1 = SIG1*SQRT( ERR1 )
         ELSE
           ERR1 = 0.0
         ENDIF

         SDEVW = ERR1*SQRT(TRY2G)

         PRINT *,' +++++++++++++++++++++++++++++++++++++++++++++++++'
         PRINT *,' MIN gen Theta tag = ',T3MIN
         PRINT *,' MAX gen Theta tag = ',T3MAX
         PRINT *,' EPAMAX = ',EPAMAX
         PRINT *,' SIGMA this iteration = ',SIG1,' +/- ',ERR1,' nbs.'

         OK2GT  = OK2GT + DBLE(OK2G)
         TRY2GT = TRY2GT + DBLE(TRY2G)
         WSTMP  = WSTMP + WSUM
         W2STMP = W2STMP + WSUMSQ

         FSUM = SNGL(WSTMP/TRY2GT)
         IF (NTAG2G .EQ. 0) THEN
           SIG1=2.*FACT2G*GGAREA*DTAG*FSUM
         ELSE IF (NTAG2G .EQ. 1) THEN
           SIG1=2.*FACT2G*GGAREA*D2GTH*DTAG*FSUM
         ELSE IF (NTAG2G .EQ. 2) THEN
           D1TMP = D1GTH/2.
           D2TMP = D2GTH/2.
           SIG1=2.*FACT2G*GGAREA*D1TMP*D2TMP*FSUM
         ELSE
           WRITE (UNIT1,*) ' ERROR IN GGACUM: NTAG2G = ',NTAG2G
         ENDIF

         ERR1  = SNGL(W2STMP/WSTMP**2 - 1.0/TRY2GT)
         IF(ERR1.LE.0.0) ERR1 = 0.0
         ERR1  = SIG1*SQRT( ERR1 )
         LUMIN = SNGL(OK2GT)/(1000.*SIG1)
         ELUM  = LUMIN*ERR1/SIG1
         PRINT *,' Accumulated SIGMA    = ',SIG1,' +/- ',ERR1,' nbs.'
         PRINT *,' LUMINOSITY = ',LUMIN,' +/- ',ELUM,' pbs.-1'

         EFF = 0.0
         IF(TRY2GT .GT. 0.0)EFF = SNGL(OK2GT/TRY2GT)
         PRINT *,' TOTAL NUMBER OF MC THROWS        = ',SNGL(TRY2GT)
         PRINT *,' TOTAL NUMBER OF GENERATED EVENTS = ',SNGL(OK2GT)
         PRINT *,' MONTE CARLO EFFICIENCY = ',EFF

         PRINT *,' -------------------------------------------------'
         OK2G   = 0.
         TRY2G  = 0.
         WSUM   = 0.0D0+00
         WSUMSQ = 0.0D0+00
      ENDIF
 10     RETURN
      ENTRY   GGREST

      OK2G   = SNGL(OK2GT)
      TRY2G  = SNGL(TRY2GT)
      WSUM   = WSTMP
      WSUMSQ = W2STMP

      OK2GT   = 0.0D+00
      TRY2GT  = 0.0D+00
      WSTMP   = 0.0D+00
      W2STMP  = 0.0D+00

      END
