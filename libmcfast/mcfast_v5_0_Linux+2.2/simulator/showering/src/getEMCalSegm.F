
      subroutine get_emcal_segm( ical, type, nsegm ) 
      
      implicit none

#include "emcal.inc"
      
      integer ical
      integer type, nsegm(2)
      
      type = emcal_par(ical).seg_type
      nsegm(1) = emcal_par(ical).ncoor2
      nsegm(2) = emcal_par(ical).ncoor1 
      
      return
      end
