      function calor_energy(ical,icr1,icr2)
c********************************************
C     5/16/96 A. Boehnlein
C     Returns the energy in an x(or phi)/y(or eta) bin for a given calorimeter
C     be sure to call this routine after the energy is smeared
c********************************************
#include "const.inc"
C input variables
      integer ical, icr1, icr2
    
C returns 
      DFLOAT calor_energy
 
c local variables
c**********************************************

      calor_energy =
     &    Sum_energy_cal_hit(%val(ical), %val(icr1), %val(icr2))
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:27  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:06  garren
c add rcs log line
c


