#include "drift_struct.inc"

c    Drift chambers

c    All variables have the prefix "drf_"

      integer max_drf
      parameter (max_drf = 10)

      integer drf_num			!Number of drift chambers
      record /drift_struct/ drf_par	!Drift chamber parameters

      common /drf_comm1/
     *  drf_num,
     *  drf_par(max_drf)

