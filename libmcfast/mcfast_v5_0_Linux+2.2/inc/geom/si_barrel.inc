#include "si_barrel_struct.inc"

c    Silicon barrel detectors

c    All variables have the prefix "sib_"

      integer max_sib
      parameter (max_sib = 15)

      integer sib_num			!Number of silicon barrel detectors
      record /si_barrel_struct/ sib_par	!Silicon barrel parameters

      common /sib_comm1/
     *  sib_num,
     *  sib_par(max_sib)
