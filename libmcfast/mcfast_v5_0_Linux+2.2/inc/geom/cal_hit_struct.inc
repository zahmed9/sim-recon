#include "cal_energy_struct.inc"
#ifndef CAL_HIT_STRUCT
#define CAL_HIT_STRUCT

c    Electromagnetic calorimeter hits
C    7/22/94  A. Boehnlein
c    5/15/96 A. Boehnlein  removed duplicate information to emcal_struct
      structure /cal_hit_struct/
      record /cal_energy_struct/ cal_hit(0:max_neta,0:max_nphi)
      end structure
#endif      
