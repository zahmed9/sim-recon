      subroutine emcal_find_cell(ical,edep,xyz,type)
c
c     Author  : Julia Yarba, FNAL/CD
c     Created : 4/1/96
c     Purpose : fill up EMC cell that contains (xyz)
c     modified 05/25/96 ASB -- adapted to modified cal hit structure
c
      implicit none
c
#include "const.inc"
#include "material.inc"
#include "emcal.inc"

#include "control_shower.inc"
		       
c
c     Calling arguments :
c
      integer ical
      real edep
      DFLOAT xyz(3)
      character*(*) type
c
c     Externals
c
      external phi_norm
      DFLOAT phi_norm
c
c     Local variables :
c 
      real r, theta, eta, phi, d_eta, d_phi 
      integer icoor1, icoor2
      integer i, mode, icalm1

c++++++++++++++++++++++++++++++++++++++++++++++++++++++
      			  
      if (ical .le. 0 .or. ical .gt. emcal_num) return

      icalm1 = ical -1

      if (emcal_par(ical).shape.ne.'BOX') then 

c Find iphi
         r = sqrt(xyz(1)**2 + xyz(2)**2)
         if (r .ne. 0.) then
             phi = phi_norm(atan2(xyz(2),xyz(1)))
         else
             phi = 0.
         end if
         d_phi = emcal_par(ical).c_coor1_size
         icoor1 = int(phi/d_phi)

         if (emcal_par(ical).seg_type.eq.0) then  ! Cone/Cyl., eta-phi segm.
            if (xyz(3) .ne. 0.) then
             theta = abs( atan(r / xyz(3)) )
            else
             theta = pi / 2.
            end if
            eta = -alog(tan(0.5*theta))
            eta = eta * sign(ONE,xyz(3)) 
c     Check for leackage to eta_min/eta_max
            if (eta .lt. emcal_par(ical).eta_min .or.
     *          eta .gt. emcal_par(ical).eta_max) return
            d_eta = emcal_par(ical).c_coor2_size
c     Find ieta 
            icoor2 = int((eta-emcal_par(ical).eta_min)/d_eta)      
         else if ( emcal_par(ical).seg_type .eq. 2 ) then  ! Cone/Cyl., z-phi
	    icoor2 = int(( xyz(3) - emcal_par(ical).zmin ) 
     *                   / emcal_par(ical).c_coor2_size)
	 else if ( emcal_par(ical).seg_type .eq. 3 ) then  ! Cyl., r-phi segm.
	    icoor2 = int(( r - emcal_par(ical).rmin(1) ) 
     *                   / emcal_par(ical).c_coor2_size)
	 endif
	 if ( icoor2 .eq. emcal_par(ical).ncoor2 ) 
     *      icoor2 = icoor2 - 1
      else
c     BOX-shaped CALs, x-y segmentation

      icoor1 = int(xyz(1)-emcal_par(ical).xlimit(1))
     *       / emcal_par(ical).c_coor1_size
      icoor2 = int(xyz(2)-emcal_par(ical).ylimit(1))
     *       / emcal_par(ical).c_coor2_size

      end if
c
c     Fill up the cell
c
      if (hit_generation) then
       if (type .eq. 'EM') then
        mode = 1
       else if (type .eq. 'MIP') then
        mode = 0
       else if (type .eq. 'HAD') then
        mode = 2
       end if
       call Set_cal_hit_showering(%val(icalm1), 
     &                            %val(icoor1), %val(icoor2), 
     &                            %val(edep), %val(mode))
      end if

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:28  eugenio
c Initial revision
c
c Revision 1.8  1999/04/16 22:47:50  yarba_j
c implemented z-phi and r-phi (tube-shaped fwd/bkwd cals only) segmentation
c
c Revision 1.7  1997/04/04  20:30:09  garren
c add rcs log line
c
