#include "sixy_disk_struct.inc"

c    Silicon disk detectors (rectangular)

c    All variables have the prefix "sixy_"

      integer max_sixy
      parameter (max_sixy = 100)

      integer sixy_num			  !Number of xy silicon disk detectors
      record /sixy_disk_struct/ sixy_par  !Silicon disk parameters

      common /sixy_comm1/
     *  sixy_num,
     *  sixy_par(max_sixy)
