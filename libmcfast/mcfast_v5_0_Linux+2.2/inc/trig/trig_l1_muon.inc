#include "offline_muon_struct.inc"

c  List of identified muons for use in level 1 trigger.

      integer ntrig_l1_muon_max
      parameter (ntrig_l1_muon_max = 100)

      integer ntrig_l1_muon                   !# of muons
      record /offline_muon_struct/ trig_l1_muon      !List of muons

      common/muon_off1/
     *  ntrig_l1_muon,
     *  trig_l1_muon(ntrig_l1_muon_max)
