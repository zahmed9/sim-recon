****************************************************************************
*  Parameters used to control shower generation
****************************************************************************

      logical shw_trans  !TRUE==>use shower transverse profile
      real thresh        !% of init.energy at which we stop tracing shower
      real e_vis_min     !minimum energy visible in calorimeters     
      integer max_ndep   !maximum number of "showering hits" per step
      logical hit_generation !TRUE==>generate hits in calorimeters 


      common/ctl_shower/
     *  shw_trans,
     *  thresh,
     *  e_vis_min,
     *  max_ndep,
     *  hit_generation
