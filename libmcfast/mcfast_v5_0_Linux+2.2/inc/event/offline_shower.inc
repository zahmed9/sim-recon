#include "offline_shower_struct.inc"

c    All reconstructed showers

      integer shw_off_max
      parameter (shw_off_max = 600)

      integer shw_off_num       !Number of showers
      record /offline_shower_s/ shw_off !List of showers
      integer idm_shof          ! alignment dummy
      common /shw_off_c/ shw_off_num, idm_shof, shw_off(shw_off_max)
