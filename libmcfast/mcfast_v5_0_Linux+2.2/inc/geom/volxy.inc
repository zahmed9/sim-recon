#include "volxy_struct.inc"

c    Volumes

c    All variables have the prefix "volxy_"

      integer max_volxy
      parameter (max_volxy = 100)

      integer volxy_num			!Number of volumes
      record /volxy_struct/ volxy_par	!Volume parameters

      common /vxy_comm1/
     *  volxy_num

      common /vxy_comm2/
     *  volxy_par(max_volxy)
