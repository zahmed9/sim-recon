#include "dipole_struct.inc"

c    Dipole magnets

c    All variables have the prefix "dip_"

      integer max_dip
      parameter (max_dip = 20)

      integer dip_num			!Number of dipoles

      common /dip_comm1/
     *  dip_num

      record /dipole_struct/ dip_par	!Dipole parameters

      common /dip_comm2/
     *  dip_par(max_dip)
