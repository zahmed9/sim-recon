      subroutine load_emcal
      implicit none
      integer cal_num_total
      integer i, j, k, lenocc
      external lenocc
      character*40 shape
      integer type
      real zmin, zmax

c     modified 5/16/96 ASB, changed emcal structure
#include "const.inc"
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "emcal.inc"

      emcal_num = min(max_emcal,n_obj_emcal)
      cal_num_total = min(max_emcal,emcal_num+n_obj_CalorBox)

      if (emcal_num.gt.0) then
        write(mcp_llpt,*) 'Loading Calorimeters'
      endif

      do i=1,emcal_num
        emcal_par(i).name = emcal(i).name(:lenocc(emcal(i).name))
        emcal_par(i).shape = emcal(i).shape(:lenocc(emcal(i).shape))     
        call upper_case(emcal_par(i).shape,emcal_par(i).shape)
        call getmat(emcal(i).material,emcal_par(i).material)
        call getmat(emcal(i).active,emcal_par(i).active_material)
        emcal_par(i).type = emcal(i).type
	if ( emcal(i).type .eq. 51 ) then
           emcal_par(i).seg_type = 2
	else if ( emcal(i).type .eq. 52 .and. 
     &            emcal_par(i).shape .eq. 'TUBE') then 
	   emcal_par(i).seg_type = 3
	else
           emcal_par(i).seg_type = 0
	end if
        do j=1,2
          emcal_par(i).rmin(j) = emcal(i).rmin(j)
          emcal_par(i).rmax(j) = emcal(i).rmax(j)
        enddo
        emcal_par(i).zmin = emcal(i).z0-emcal(i).zlen/2.
        emcal_par(i).zmax = emcal(i).z0+emcal(i).zlen/2.
        emcal_par(i).ncoor1 = emcal(i).nphi
cc-   temporary fix; now allows ANY number of phi-segments
cc-	if (emcal_par(i).ncoor1 .gt. max_ncoor1) then
cc-         print *, "Finer phi segmentation than allowed, truncating nphi"
cc-         emcal_par(i).ncoor1 = max_ncoor1
cc-	endif
        emcal_par(i).ncoor2 = emcal(i).neta
cc-   temporary fix; now allows ANY number of eta-segments
cc-	if (emcal_par(i).ncoor2 .gt. max_ncoor2) then
cc-         print *, "Finer eta segmentation than allowed, truncating neta"
cc-         emcal_par(i).ncoor2 = max_ncoor2
cc-	endif
        emcal_par(i).nlayers = emcal(i).nlayers
        if (emcal_par(i).nlayers .lt. 1) emcal_par(i).nlayers = 1
        emcal_par(i).siga_em = emcal(i).siga_em
        emcal_par(i).sigb_em = emcal(i).sigb_em
        emcal_par(i).siga_had = emcal(i).siga_had
        emcal_par(i).sigb_had = emcal(i).sigb_had
        emcal_par(i).em_had_ratio = emcal(i).em_had_ratio
        emcal_par(i).zerosup  = 0.001
        call geteta(emcal(i).type,emcal(i).rmin,emcal(i).rmax,
     +    emcal_par(i).zmin,emcal_par(i).zmax,
     +    emcal_par(i).eta_min,emcal_par(i).eta_max)
c
        emcal_par(i).c_coor1_size = (2.*pi)/float(emcal_par(i).ncoor1)
	if ( emcal_par(i).seg_type .eq. 0 ) then 
           emcal_par(i).c_coor2_size = ( emcal_par(i).eta_max -
     +        emcal_par(i).eta_min ) / float(emcal_par(i).ncoor2)
        else if ( emcal_par(i).seg_type .eq. 2 ) then
	   emcal_par(i).c_coor2_size = ( emcal_par(i).zmax -
     &        emcal_par(i).zmin ) / float(emcal_par(i).ncoor2)
	else if ( emcal_par(i).seg_type .eq. 3 ) then
	   emcal_par(i).c_coor2_size = ( emcal_par(i).rmax(1) -
     &        emcal_par(i).rmin(1) ) / float(emcal_par(i).ncoor2)
	endif
c
        write(mcp_llpt,'(a,4f9.3)') '   Calor. '//
     +    emcal_par(i).name(:lenocc(emcal_par(i).name))//
     +    ' in/active'//
     +    emcal(i).material(:lenocc(emcal(i).material))//' '//
     +    emcal(i).active(:lenocc(emcal(i).active))//
     +    ' zmin, zmax, etamin, etamax',
     +    emcal_par(i).zmin,emcal_par(i).zmax,
     +    emcal_par(i).eta_min,emcal_par(i).eta_max
      enddo

      if (cal_num_total.gt.emcal_num) then
        write(mcp_llpt,*) 'Loading BOX-shaped calorimeters'
      endif

      i = emcal_num
      do k=1,cal_num_total-emcal_num
        shape = CalorBox(k).shape(:lenocc(CalorBox(k).shape))
        call upper_case(shape,shape)
        type = CalorBox(k).type
        if (type .eq. 1 .and. shape .eq. 'BOX') then
         write(mcp_llpt,*) 
     *   'CALORIMETRY : Only Forward BOX possible, type converted'
         type = 2
        end if
        zmin = CalorBox(k).z0-CalorBox(k).zlen/2.
        zmax = CalorBox(k).z0+CalorBox(k).zlen/2.
        if (shape.eq.'BOX' .and. zmin.lt.0. .and. zmax.gt.0.) then
         write(mcp_llpt,*)
     *'CALORIMETRY: Only Forward BOX, skip because of z-range'            
         goto 100
        end if
        i = i + 1
        emcal_par(i).name = 
     *   CalorBox(k).name(:lenocc(CalorBox(k).name))
        emcal_par(i).shape = shape
        call getmat(CalorBox(k).material,emcal_par(i).material)
        call getmat(CalorBox(k).active,emcal_par(i).active_material)
        emcal_par(i).type = type
        emcal_par(i).seg_type = 1
        do j=1,2
          emcal_par(i).xlimit(j) = CalorBox(k).xlimit(j)
          emcal_par(i).ylimit(j) = CalorBox(k).ylimit(j)
          emcal_par(i).xlimit_gap(j) = CalorBox(k).xlimit_gap(j)
          emcal_par(i).ylimit_gap(j) = CalorBox(k).ylimit_gap(j)
        enddo
        emcal_par(i).zmin = zmin
        emcal_par(i).zmax = zmax
        emcal_par(i).ncoor1 = CalorBox(k).ncr1
        emcal_par(i).ncoor2 = CalorBox(k).ncr2
        emcal_par(i).c_coor1_size = 
     *  (emcal_par(i).xlimit(2)-emcal_par(i).xlimit(1)) /
     *  float(emcal_par(i).ncoor1)
        emcal_par(i).c_coor2_size = 
     *  (emcal_par(i).ylimit(2)-emcal_par(i).ylimit(1)) /
     *  float(emcal_par(i).ncoor2)
        emcal_par(i).nlayers = CalorBox(k).nlayers
        if (emcal_par(i).nlayers .lt. 1) emcal_par(i).nlayers = 1
        emcal_par(i).siga_em = CalorBox(k).siga_em
        emcal_par(i).sigb_em = CalorBox(k).sigb_em
        emcal_par(i).siga_had = CalorBox(k).siga_had
        emcal_par(i).sigb_had = CalorBox(k).sigb_had
        emcal_par(i).em_had_ratio = CalorBox(k).em_had_ratio
        emcal_par(i).zerosup  = 0.001
c
        write(mcp_llpt,'(a,2f9.3)') '   Calor. '//
     +    emcal_par(i).name(:lenocc(emcal_par(i).name))//
     +    ' in/active'//
     +    CalorBox(k).material(:lenocc(CalorBox(k).material))//' '//
     +    CalorBox(k).active(:lenocc(CalorBox(k).active))//
     +    ' zmin, zmax',
     +    emcal_par(i).zmin,emcal_par(i).zmax
        emcal_num = i
  100  enddo

      end        

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.15  1999/04/16 22:49:11  yarba_j
c implemented z-phi and r-phi (tube-shaped fwd/bkwd cals only) segmentation
c
c Revision 1.14  1999/02/22  23:20:07  yarba_j
c z-phi segmentation for central calorimeters (type=51) and r_phi segmentation for forward/backward calorimeters(type=52)
c
c Revision 1.13  1999/02/17  00:01:39  yarba_j
c z-phi segmentation now available
c
c Revision 1.12  1997/04/04  20:29:50  garren
c add rcs log line
c
