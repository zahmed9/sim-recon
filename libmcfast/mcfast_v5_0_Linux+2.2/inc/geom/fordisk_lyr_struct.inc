#include "fordisk_slice_struct.inc"
#ifndef fordisk_LYR_STRUCT
#define fordisk_LYR_STRUCT

c                            P.L. McBride May 27, 1996
c  parameter phi(2) - it allows a layer to be not a disk
c   but also a "fan" (not 360 degree coverage)
c
c   Forward (circular or 'fan') disk layer definition.
c
      integer max_fordisk_slice
      parameter (max_fordisk_slice=16)

      structure /fordisk_lyr_struct/
        real phi(2)             !phi-range covered by layer
        integer numslice        !number of slices per layer
        integer nchan           !number of channel in this layer
        record /fordisk_slice_struct/ 
     *          slice(max_fordisk_slice) ! slice parameter
      end structure
#endif
