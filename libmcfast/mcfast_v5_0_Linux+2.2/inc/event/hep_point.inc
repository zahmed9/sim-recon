#ifndef HEP_POINT_INC
#define HEP_POINT_INC

#include "const.inc"

c
c   Rob Kutschke, Oct. 23, 1998.
c
c   Arrays of pointers from the hep list into various track lists  
c
c                                   Mike Procario  
c                                   10 Apr 1995
c
c
c   -------------------------------------------------------
c
c   WARNING: if you change this file, also make sure you change
c            hep_point.h !
c
c   --------------------------------------------------------
c

      integer    max_point
      parameter (max_point = mcf_nmxhep)
      integer   
     &    hep_off             ,! Position in the offline track list
     &    hep_cen             ,! Position in the central track list
     &    hep_for             ,! Position in the forward track list
     &    hep_gen              ! Generated track list 

      common /hep_point/ 
     &    hep_off(max_point)  ,
     &    hep_cen(max_point)  ,
     &    hep_for(max_point)  ,
     &    hep_gen(max_point)

#endif

