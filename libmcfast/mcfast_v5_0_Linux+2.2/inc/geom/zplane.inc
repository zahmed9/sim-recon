******************************************************************************
*  List of tracking chambers or materials along z
******************************************************************************

#include "zplane_struct.inc"

      integer zpln_max
      parameter (zpln_max = 800)

      integer zpln_num          !Number of zplane planes
      integer zpln_up           !List of planes ordered by increasing z
      integer zpln_dn           !List of planes ordered by decreasing z
      record /zplane_struct/ zpln_par   !Plane contents

      common/zpl_comm1/
     *  zpln_num,
     *  zpln_up(zpln_max),
     *  zpln_dn(zpln_max),
     *  zpln_par(zpln_max)
