*
* $Id$
*
* $Log$
* Revision 1.1  2000/06/19 20:00:34  eugenio
* Initial revision
*
* Revision 1.1.1.1  1994/10/08  02:21:28  zfiles
* first version of qqlib in CVS
*
*
#include "sys/CLEO_machine.h"
#include "pilot.h"
*CMZ :  1.03/22 18/09/91  17.16.22  by  Peter C Kim
*CMZ :  1.00/00 04/06/90  18.55.46  by  Jorge L. Rodriguez
*-- Author :

      FUNCTION EXACT(K,Z,X,C,X1,C1)

C...CALCULATES EXACT CROSSECTION FOR THREE GAMMA PRODUCTION
      IMPLICIT DOUBLE PRECISION(A-Z)
C   DUMMY added by PA to make COMMON right length 6-11-85
      COMMON / CON1 / PI,M,ALFA,PI2,LE,E,DL,MU,S,DUMMY(8)
C...CONSTRUCT SIX DOT PRODUCTS

      K11=K*(E-Z)
      K12=K*(E+Z)
      K21=X*(E-C)
      K22=X*(E+C)
      K31=X1*(E-C1)
      K32=X1*(E+C1)
C...CROSSECTION
C      EXACT=-2.D0*M**2*((K22/K32+K32/K22)/K11**2
C     Z               +(K21/K31+K31/K21)/K12**2
C     Z               +(K12/K32+K32/K12)/K21**2
C     Z               +(K11/K31+K31/K11)/K22**2
C     Z               +(K12/K22+K22/K12)/K31**2
C     Z               +(K11/K21+K21/K11)/K32**2)
C     Z   +4.D0*E**2/K11/K12/K21/K22/K31/K32
C     Z            *(  K11*K12*(K11**2+K12**2)
C     Z               +K21*K22*(K21**2+K22**2)
C     Z               +K31*K32*(K31**2+K32**2) )
C
C The full expression gives the mips compiler fits (if -g is specified),
C so break it into byte-sized pieces.
C     -dsr, 9/18/91
C
      T1 =      (K22/K32+K32/K22)/K11**2
      T1 = T1 + (K21/K31+K31/K21)/K12**2
      T1 = T1 + (K12/K32+K32/K12)/K21**2
      T1 = T1 + (K11/K31+K31/K11)/K22**2
      T1 = T1 + (K12/K22+K22/K12)/K31**2
      T1 = T1 + (K11/K21+K21/K11)/K32**2
      T2 =      K11*K12*(K11**2+K12**2)
      T2 = T2 + K21*K22*(K21**2+K22**2)
      T2 = T2 + K31*K32*(K31**2+K32**2)
      EXACT = -2.D0*M**2*T1 + 4.D0*E**2/K11/K12/K21/K22/K31/K32*T2
C...NORMALIZATION AND RETURN
      EXACT=ALFA**3/8.D0/PI2/S*EXACT
      RETURN
      END
