#include "solenoid_struct.inc"

c    Solenoid magnets

c    All variables have the prefix "sol_"

      integer max_sol
      parameter (max_sol = 10)

      integer sol_num			!Number of solenoids

      common /sol_comm1/
     *  sol_num

      record /solenoid_struct/ sol_par	!Solenoid parameters

      common /sol_comm2/
     *  sol_par(max_sol)
