#ifndef CAL_ENERGY_STRUCT
#define CAL_ENERGY_STRUCT

c   calorimeter hit structure 
c   7/22/94 A. Boehnlein
C   modifed 5/17/96 ASB-- cleaned up unnecessary elements

      structure /cal_energy_struct/
        real E_mip
        real E_em
        real E_had
        integer nhit            ! 1000*n_charged particles + n_gamma
      end structure
#endif
