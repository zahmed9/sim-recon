#include "sixy_disk_layer_struct.inc"
#ifndef SIXY_DISK_STRUCT
#define SIXY_DISK_STRUCT

c
c   Update history :
c   Nov.18, 1994 - # number of layers increase to 30 (instead of 10)
c   Feb. 23, 1996 - # number of layers increase to 500
c
c   Silicon disk detector (rectangular) definition. Several of these can
c   be defined at one time.
c
c   The resolution function is given by sig = a + b*costh +c*costh**2,
c   where all units are in meters.

      integer max_sixy_lyr
      parameter (max_sixy_lyr = 100)

      structure /sixy_disk_struct/
        integer numlyr		!# of layers
        integer nchan           !total # of channel in the device
        real    z               !"global" z-position of the device
        record /sixy_disk_layer_struct/
     *      lyr(max_sixy_lyr)	!Layer params
        character*40 name	!Name of device
      end structure
#endif
