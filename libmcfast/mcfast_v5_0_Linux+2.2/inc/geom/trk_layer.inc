***************************************************************************
*  Pointers from tracking layer to individual device type, device number
*  and device layer
***************************************************************************

#include "trk_layer_struct.inc"

      integer trk_layer_max             !Max number of tracking layers
      parameter (trk_layer_max = 400)

      integer trk_layer_num                 !Number of tracking layers
      record /trk_layer_struct/ trk_layer   !Tracking layer info

      common/trk_layer_comm1/
     *  trk_layer_num,
     *  trk_layer(trk_layer_max)
