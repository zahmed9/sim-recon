      subroutine muon_dedx(w,s,bf,dedx)
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    find the material in front of the muon detector
c
c
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "emcal.inc"
#include "hadcal.inc"
#include "absorber.inc"
#include "bfield_struct.inc"
#include "wtrack_struct.inc"
 
      record /wtrack_struct/ w
      record /bfield_struct/ bf
      DFLOAT s                                 ! path length to mu-det
      real dedx   


c     Local variables 
      record /absorber_struct/ absorb_mat
      integer i
   

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      dedx = 0.
      if (s .le. 0.) return
      
      do i = 1, emcal_num
          absorb_mat.type  = emcal_par(i).type
          absorb_mat.shape = emcal_par(i).shape
          absorb_mat.material = emcal_par(i).material
          absorb_mat.name  = emcal_par(i).name
          call ucopy(emcal_par(i).rmin(1),absorb_mat.rmin(1),8)
          call muon_absorb(w,s,bf,absorb_mat,dedx)
      enddo
      
      do i = 1, hcal_num
          absorb_mat.type  = hcal_par(i).type
          absorb_mat.shape = hcal_par(i).shape
          absorb_mat.material = hcal_par(i).material
          absorb_mat.name  = hcal_par(i).name
          call ucopy(hcal_par(i).rmin(1),absorb_mat.rmin(1),8)
          call muon_absorb(w,s,bf,absorb_mat,dedx)
      enddo
      
      do i = 1, absorber_num
          absorb_mat.type  = absorber_par(i).type
          absorb_mat.shape = absorber_par(i).shape
          absorb_mat.material = absorber_par(i).material
          absorb_mat.name  = absorber_par(i).name
          call ucopy(absorber_par(i).rmin(1),absorb_mat.rmin(1),8)
          call muon_absorb(w,s,bf,absorb_mat,dedx)
      enddo
      
      if (dedx .lt. 0.) then
          print *, 'error in dedx'
          dedx = 0.
      endif
      
      return
      end
  
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:26  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:03  garren
c add rcs log line
c
      
