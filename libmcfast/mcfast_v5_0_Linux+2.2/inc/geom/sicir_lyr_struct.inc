#include "sicir_wedge_struct.inc"
#ifndef SICIR_LYR_STRUCT
#define SICIR_LYR_STRUCT

c                             Julia Yarba, Oct.24, 1994
c   added new parameter phi(2) - it allows a layer to be not a disk
c   but also a "fan" (not 360 degree coverage)
c   june 28, 1996 asb increased number of layers to 80
c
c   Silicon (circular or 'fan') disk layer definition.
c
      integer max_sicir_wedge
      parameter (max_sicir_wedge=80)

      structure /sicir_lyr_struct/
        real phi(2)             !phi-range covered by layer
        integer numwedge        !number of wedges per layer
        integer nchan           !number of channel in this layer
        record /sicir_wedge_struct/ 
     *          wedge(max_sicir_wedge) !silicon wedge parameter
      end structure
#endif
