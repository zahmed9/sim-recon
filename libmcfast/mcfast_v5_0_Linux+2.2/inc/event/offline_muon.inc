#include "offline_muon_struct.inc"

c  List of offline identified muons.

      integer muon_off_max
      parameter (muon_off_max = 50)

      integer muon_off_num      !# of muons
      record /offline_muon_struct/ muon_off !List of muons
      integer idm_muof          ! alignment dummy
      common/muon_off_c/
     +  muon_off_num, idm_muof, muon_off(muon_off_max)
