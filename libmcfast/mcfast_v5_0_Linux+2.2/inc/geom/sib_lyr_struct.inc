#include "sib_plane_struct.inc"
#ifndef SIB_LYR_STRUCT
#define SIB_LYR_STRUCT
c modified 6/26/96 asb, increased number of planes to 110 to accomodate
C Atlas

c   Silicon barrel layer definition.
c
      integer max_sib_plane
      parameter (max_sib_plane = 110)

      structure /sib_lyr_struct/
        integer numplane             !Number of planes in the layer
        integer nchan                !Number of channels in this layer
        integer chan0                !Channel # corres. to 1st strip
        record /sib_plane_struct/
     *        plane(max_sib_plane)   !Plane params
      end structure
#endif
