#include "siz_rect_wafer_struct.inc"
#ifndef SIZ_RECT_LAYER_STRUCT
#define SIZ_RECT_LAYER_STRUCT

c   Silicon layer information for rectangular disk detector.
c
c   The resolution function is given by sig = a + b*costh +c*costh**2,
c   where all units are in meters.

      integer max_siz_rect_wafer
      parameter (max_siz_rect_wafer = 200)

      structure /siz_rect_layer_struct/
        integer nwafer       !# of wafers
        integer nchan        !total # of channels in the layer
        real xCenter         !x-center of layer in global coord.sys.
        real yCenter         !y-center of layer in global coord.sys.
        real zCenter         !average z-position of layer in global coord.sys.
        real xGapMinLocal    !xmin of gap (in layer coord.system)
        real xGapMaxLocal    !xmax of gap (in layer coord.system)
        real yGapMinLocal    !ymin of gap (in layer coord.system)
        real yGapMaxLocal    !ymax of gap (in layer coord.system)
        real rotate          !layer rotation about z-axis
        record /siz_rect_wafer_struct/
     *      wfr(max_siz_rect_wafer)  !Wafer params
        character*40 name              !Name of layer
      end structure
#endif
