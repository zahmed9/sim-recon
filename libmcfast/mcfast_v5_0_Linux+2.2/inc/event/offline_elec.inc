#include "offline_elec_struct.inc"

c  List of offline identified electrons.

      integer elec_off_max
      parameter (elec_off_max = 50)

      integer elec_off_num                   !# of electrons
      record /off_elec_s/ elec_off      !List of electrons
      integer idum_eloff        ! alignment dummy
      common/elec_off_c/
     *  elec_off_num, idum_eloff, elec_off(elec_off_max)
