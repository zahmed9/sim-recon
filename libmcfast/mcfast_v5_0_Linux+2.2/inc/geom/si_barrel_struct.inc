#include "sib_lyr_struct.inc"
#ifndef SI_BARREL_STRUCT
#define SI_BARREL_STRUCT

c
c   Update history ;
c   Nov.18, 1994 - number of layers increases to 30 (instead of 10)
c
c   Silicon barrel detector definition. Several of these can be defined
c   at one time.

      integer max_sib_lyr
      parameter (max_sib_lyr = 30)

      structure /si_barrel_struct/
        integer numlyr		!Number of layers
        integer nchan           !Total # of channels
        record /sib_lyr_struct/ lyr(max_sib_lyr) !Layer params
        character*40 name	!Name of device
        real z                  !"global" z-position of device
      end structure
#endif
