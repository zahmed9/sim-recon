#include "hadcal_struct.inc"


c    Hadronic calorimeters

c    All variables have the prefix "hcal_"
c    11/14/95 J.Yarba - added common for hit structure

      integer max_hcal
      parameter (max_hcal = 1)

      integer hcal_num			!Number of hcal detectors

      common /hcal_comm1/
     *  hcal_num

      record /hadcal_struct/ hcal_par	!Hadron calorimeter parameters

      common /hcal_comm2/
     *  hcal_par(max_hcal)

