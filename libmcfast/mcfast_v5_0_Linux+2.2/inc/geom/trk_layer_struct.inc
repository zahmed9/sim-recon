#ifndef TRK_LAYER_STRUCT
#define TRK_LAYER_STRUCT

***************************************************************************
*  Defines structure pointing back to device & layer where this tracking
*  layer comes from.
***************************************************************************

      structure /trk_layer_struct/
        integer devtype             !Track device type
        integer devnum              !Device number of that type
        integer devlayer            !Device layer
        character*40 name           !Name of layer
      end structure

#endif
