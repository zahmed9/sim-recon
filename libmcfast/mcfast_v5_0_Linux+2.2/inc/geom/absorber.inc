#include "absorber_struct.inc"

c    Absorbers

c    All variables have the prefix "absorber_"

      integer max_absorber
      parameter (max_absorber = 25)

      integer absorber_num			!Number of absorbers
      record /absorber_struct/ absorber_par	!Absorbers parameters

      common /absorber_comm1/
     *  absorber_num

      common /absorber_comm2/
     *  absorber_par(max_absorber)
