#include "volume_struct.inc"

c    Volumes

c    All variables have the prefix "vol_"

      integer max_vol
      parameter (max_vol = 100)

      integer vol_num			!Number of volumes
      record /vol_struct/ vol_par	!Volume parameters

      common /vol_comm1/
     *  vol_num

      common /vol_comm2/
     *  vol_par(max_vol)
