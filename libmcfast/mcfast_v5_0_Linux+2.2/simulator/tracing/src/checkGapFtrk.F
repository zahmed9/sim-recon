
      subroutine check_ftrk_gap( w, index, lstrike )
      
      implicit none
      
#include "zplane.inc" 
#include "zplane_types.inc"     
#include "wtrack_struct.inc"

      record /wtrack_struct/ w
      integer index
      
      logical lstrike
      
      integer dev, lyr, devtype
      DFLOAT eta(3)
      
c===========================================================

      lstrike = .true.
      
      if ( zpln_par(index).shape .gt. 100 ) then
         dev = zpln_par(index).pos(1)
	 lyr = zpln_par(index).pos(2)
	 devtype = zpln_par(index).shape - 100
	 if (devtype .eq. jzpl_material) then
	    call trk_find_absorber(w, dev, lstrike )
	 else if ( devtype .eq. jzpl_drift ) then
	    call trk_find_ftrk_plane(w, dev, lyr, lstrike, eta)
	 endif
      end if
      
      return
      end
