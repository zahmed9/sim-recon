******************************************************************************
*  List of tracking chambers or materials along radial direction
******************************************************************************

#include "rplane_struct.inc"

      integer rpln_max
      parameter (rpln_max = 300)

      integer rpln_num          !Number of radial planes
      integer rpln_up           !List of planes ordered by increasing r
      record /rplane_struct/ rpln_par   !Plane contents

      common/rplane_comm1/
     *  rpln_num,
     *  rpln_up(rpln_max),
     *  rpln_par(rpln_max)
