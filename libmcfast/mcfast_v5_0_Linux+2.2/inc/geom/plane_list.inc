******************************************************************************
*  List of radial and z plane indices. Every volume has entries in this list.
******************************************************************************

      integer rpln_list_max
      integer zpln_list_max
      parameter (rpln_list_max = 200)
      parameter (zpln_list_max = 200)

      integer rpln_list_num          !Number of radial planes
      integer zpln_list_um           !Number of z planes
      integer rpln_list              !List of radial planes in rplane.inc
      integer zpln_list              !List of z planes in zplane.inc

      common/plane_list_comm1/
     *  rpln_list_num,
     *  zpln_list_num,
     *  rpln_list(rpln_list_max),
     *  zpln_list(zpln_list_max)
