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
*CMZ :  1.03/15 05/12/90  05.03.25  by  R.A.FULTON
*-- Author :
      FUNCTION GGDK(JSPIN,LAM,COSMAX)
C***********************************************
C ANGULAR DISTRIBUTIONS FOR RESONANCE DECAYS.
C FUNCTION VALUE IS A COSINE.
C***********************************************
       REAL      GGDK

       INTEGER   JSPIN
       REAL      LAM, COSMAX

       INTEGER   JBRNCH, NSPIN
       REAL      EFTOT, DUM

       REAL      RANP
       EXTERNAL  RANP


      JBRNCH  =  JSPIN + 1
      GOTO (100,200,300),JBRNCH

C SPIN 0 CASE
 100  GGDK = (2.0*RANP(DUM) - 1.0)*COSMAX
      RETURN

C SPIN 1 CASE
C DISTINGUISH BETWEEN HELICITY : 0 OR 1

 200  IF(LAM.NE.0)GOTO 250
      GGDK=COSMAX*RANP(DUM)**0.33333333
      IF(RANP(DUM).GT.0.5) GGDK=-GGDK
      RETURN
 250  GGDK=(2.0*RANP(DUM)-1.0)*COSMAX
      EFTOT=1.-GGDK*GGDK
      IF(RANP(DUM).GE.EFTOT)GOTO 250
      RETURN

C SPIN 2 CASE
C DISTINGUISH BETWEEN HELICITY : 0,1 OR 2
 300  NSPIN=LAM+1
      GOTO (350,360,370),NSPIN
 350  GGDK = (2.0*RANP(DUM) - 1.0)*COSMAX
      EFTOT=(1.5*GGDK*GGDK-0.5)**2
      IF(RANP(DUM).GE.EFTOT)GOTO 350
      RETURN
 360  GGDK = (2.0*RANP(DUM) - 1.0)*COSMAX
      EFTOT=(1.-GGDK*GGDK)*GGDK*GGDK
      IF(.25*RANP(DUM).GE.EFTOT)GOTO 360
      RETURN
 370  GGDK = (2.0*RANP(DUM) - 1.0)*COSMAX
      EFTOT=(1.-GGDK*GGDK)**2
      IF(RANP(DUM).GE.EFTOT)GOTO 370
      RETURN
      END
