#include "beampipe_struct.inc"

c    Beam Pipe definition for detectors with several beampipes

      integer max_beampipe
      parameter (max_beampipe = 20)
      
      integer beampipe_num

      record /beampipe_struct/ beampipe_par  !beam pipe parameters
      
      common /beampipe_comm1/ beampipe_num   ! Number of beam pipes
      
      common /beampipe_comm2/ beampipe_par(max_beampipe)
