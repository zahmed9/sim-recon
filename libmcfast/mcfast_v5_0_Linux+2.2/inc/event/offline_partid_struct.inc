#ifndef OFFLINE_PARTID_STRUCT
#define OFFLINE_PARTID_STRUCT

      structure /offline_partid_s/
        integer track   !Track number in offline track list
        real prob(5)    !Probability of particle ID for e/mu/pi/K/p
      end structure
#endif
