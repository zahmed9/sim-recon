#include "muon_struct.inc"

c    Muon detectors

c    All variables have the prefix "muon_"

      integer max_muon
      parameter (max_muon = 40)

      integer muon_num			!Number of muon detectors
      record /muon_struct/ muon_par	!Muon detector parameters

      common /muon_comm1/
     *  muon_num

      common /muon_comm2/
     *  muon_par(max_muon)
