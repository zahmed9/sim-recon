#include "siz_rect_layer_struct.inc"
#ifndef SIZ_RECT_STRUCT
#define SIZ_RECT_STRUCT

c
c   Silicon disk detector (rectangular) definition. Several of these can
c   be defined at one time.
c
c   The resolution function is given by sig = a + b*costh +c*costh**2,
c   where all units are in meters.

      integer max_siz_rect_lyr
      parameter (max_siz_rect_lyr = 20)

      structure /siz_rect_struct/
        integer nlayer		!# of layers
        integer nwafer		!# of wafers
        integer nchan           !total # of channel in the device
        real    x               !"global" x-position of the device
        real    y               !"global" y-position of the device
        real    z               !"global" z-position of the device
        record /siz_rect_layer_struct/
     *      lyr(max_siz_rect_lyr)  !Layer params
        character*40 name	   !Name of device
      end structure
#endif
