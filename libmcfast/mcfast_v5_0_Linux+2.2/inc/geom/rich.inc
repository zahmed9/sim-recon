c
#include "rich_struct.inc"
c
c    Threshold Cerenkov detectors

c    All variables have the prefix "certh_"

      integer max_certh
      parameter (max_certh = 10)

      integer certh_num			!Number of Cerenkov detectors

      common /certh_comm1/
     *  certh_num

      record /rich_struct/ certh_par	!Cerenkov parameters

      common /certh_comm2/
     *  certh_par(max_certh)
