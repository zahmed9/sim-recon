      subroutine load_absorber
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c     added box absorbers
c     read thick absorbers into calorimeter
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      implicit none
      
#include "const.inc"
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "absorber.inc"
#include "emcal.inc"

      integer i, j, k, ical
      integer abs_num, absorber_num_total
      integer lenocc
      external lenocc
      character*40 shape
      integer type
      real zmin, zmax

c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      

      abs_num = min(max_absorber,n_obj_absorber)
      absorber_num_total = 
     *min(max_absorber,abs_num+n_obj_AbsorberBox)

      if (abs_num.gt.0) then
        write(mcp_llpt,*) 'Loading absorbers'
      endif
*
      do i=1,abs_num
       if (absorber(i).type .gt. 10) then
        absorber_par(i).type = absorber(i).type
        absorber_par(i).shape = 
     *  absorber(i).shape(:lenocc(absorber(i).shape))
        call upper_case(absorber_par(i).shape,absorber_par(i).shape)
        do j=1,2
          absorber_par(i).rmin(j) = absorber(i).rmin(j)
          absorber_par(i).rmax(j) = absorber(i).rmax(j)
        enddo
        absorber_par(i).zmin = absorber(i).z0-absorber(i).zlen/2.
        absorber_par(i).zmax = absorber(i).z0+absorber(i).zlen/2.
        absorber_par(i).name = 
     *  absorber(i).name(:lenocc(absorber(i).name))
***       from material name, retrieve index
        call getmat(absorber(i).material,absorber_par(i).material)
*
***       calculate eta
        call geteta(absorber_par(i).type,
     +    absorber_par(i).rmin,absorber_par(i).rmax,
     +    absorber_par(i).zmin,absorber_par(i).zmax,
     +    absorber_par(i).eta_min, absorber_par(i).eta_max)
*
        write(mcp_llpt,6000) 
     +    absorber_par(i).name(:lenocc(absorber_par(i).name)),i,
     +    absorber_par(i).zmin,
     +    absorber_par(i).zmax,absorber_par(i).eta_min,
     +    absorber_par(i).eta_max
 6000   format('   Absorber ',a,': num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 

        absorber_num = absorber_num + 1

       else

        emcal_num = emcal_num + 1

        if (emcal_num .gt. max_emcal) return
        ical = emcal_num
        emcal_par(ical).name = 
     +        absorber(i).name(:lenocc(absorber(i).name))
        emcal_par(ical).shape = 
     +        absorber(i).shape(:lenocc(absorber(i).shape))
        call upper_case(emcal_par(ical).shape,emcal_par(ical).shape)
        call getmat(absorber(i).material,emcal_par(ical).material)
        call getmat(absorber(i).material,
     +        emcal_par(ical).active_material)
        emcal_par(ical).type = absorber(i).type + 100
        emcal_par(ical).seg_type = 0
        do j=1,2
           emcal_par(ical).rmin(j) = absorber(i).rmin(j)
           emcal_par(ical).rmax(j) = absorber(i).rmax(j)
        enddo
        emcal_par(ical).zmin = absorber(i).z0-absorber(i).zlen/2.
        emcal_par(ical).zmax = absorber(i).z0+absorber(i).zlen/2.
        emcal_par(ical).ncoor1 = 1
        emcal_par(ical).ncoor2 = 1
        emcal_par(ical).siga_em = 0.
        emcal_par(ical).sigb_em = 0.
        emcal_par(ical).siga_had = 0.
        emcal_par(ical).sigb_had = 0.
        emcal_par(ical).em_had_ratio = 1.
        emcal_par(ical).zerosup  = 0.001
        call geteta(absorber(i).type,absorber(i).rmin,absorber(i).rmax,
     +      emcal_par(ical).zmin,emcal_par(ical).zmax,
     +      emcal_par(ical).eta_min,emcal_par(ical).eta_max)
c
        emcal_par(ical).c_coor2_size = (emcal_par(ical).eta_max
     +                               -  emcal_par(ical).eta_min)
     +                               /  float(emcal_par(ical).ncoor2)
        emcal_par(ical).c_coor1_size = (2.*pi)
     +                            / float(emcal_par(ical).ncoor1)
c
        write(mcp_llpt,'(a,4f9.3)') '   Absorber '//
     +    emcal_par(ical).name(:lenocc(emcal_par(ical).name))//
     +    ' in/active'//
     +    absorber(i).material(:lenocc(absorber(i).material))//' '//
     +    absorber(i).material(:lenocc(absorber(i).material))//
     +    ' zmin, zmax, etamin, etamax',
     +    emcal_par(ical).zmin,emcal_par(ical).zmax,
     +    emcal_par(ical).eta_min,emcal_par(ical).eta_max                
       end if
      enddo

      if (absorber_num_total.gt.abs_num) then
        write(mcp_llpt,*) 'Loading BOX-shaped absorbers'
      endif
     
      i = absorber_num
      do k=1,absorber_num_total-abs_num
       type = AbsorberBox(k).type
       shape = 
     + AbsorberBox(k).shape(:lenocc(AbsorberBox(k).shape))
       call upper_case(shape,shape)
       zmin = AbsorberBox(k).z0 - AbsorberBox(k).zlen/2.
       zmax = AbsorberBox(k).z0 + AbsorberBox(k).zlen/2.
       if (mod(type,10) .eq. 1 .and. shape .eq. 'BOX') then 
         write(mcp_llpt,*) 'Only Forward BOXes possible, type converted'
         type = type + 1         
       end if
       if (shape.eq.'BOX' .and. zmin.lt.0. .and. zmax.gt.0.) then
        write(mcp_llpt,*)
     *'ABSORBER: Only Forward BOX possible, skip because of z-range'
        goto 100
       end if
       i = i + 1
       if (type .gt. 10) then 
        absorber_par(i).type = type 
        absorber_par(i).shape = shape
        do j=1,2
          absorber_par(i).xlimit(j) = AbsorberBox(k).xlimit(j)
          absorber_par(i).ylimit(j) = AbsorberBox(k).ylimit(j)
          absorber_par(i).xlimit_gap(j) = 
     *    AbsorberBox(k).xlimit_gap(j)
          absorber_par(i).ylimit_gap(j) = 
     *    AbsorberBox(k).ylimit_gap(j)
        enddo
        absorber_par(i).zmin = zmin
        absorber_par(i).zmax = zmax
        absorber_par(i).name = 
     *  AbsorberBox(k).name(:lenocc(AbsorberBox(k).name))
***       from material name, retrieve index
        call getmat(AbsorberBox(k).material,absorber_par(i).material)
*
        write(mcp_llpt,7000) 
     +    absorber_par(i).name(:lenocc(absorber_par(i).name)),i,
     +    absorber_par(i).zmin,
     +    absorber_par(i).zmax
 7000   format('   Absorber ',a,': num,zmin,zmax', 
     +         i3,2f10.4) 
        absorber_num = i
       else
        emcal_num = emcal_num + 1
        if (emcal_num .gt. max_emcal) return
        ical = emcal_num
        emcal_par(ical).name = 
     +        AbsorberBox(k).name(:lenocc(AbsorberBox(k).name))
        emcal_par(ical).shape = shape
        emcal_par(ical).type = type + 100
        call getmat(AbsorberBox(k).material,emcal_par(ical).material)
        call getmat(AbsorberBox(k).material,
     +        emcal_par(ical).active_material)
        emcal_par(ical).seg_type = 1
        do j=1,2
           emcal_par(ical).xlimit(j) = AbsorberBox(k).xlimit(j)
           emcal_par(ical).ylimit(j) = AbsorberBox(k).ylimit(j)
           emcal_par(ical).xlimit_gap(j) = 
     *     AbsorberBox(k).xlimit_gap(j)
           emcal_par(ical).ylimit_gap(j) = 
     *     AbsorberBox(k).ylimit_gap(j)
        enddo
        emcal_par(ical).zmin = zmin
        emcal_par(ical).zmax = zmax
        emcal_par(ical).ncoor1 = 1
        emcal_par(ical).ncoor2 = 1
        emcal_par(ical).c_coor1_size = 
     +  emcal_par(ical).xlimit(2) - emcal_par(ical).xlimit(1)
        emcal_par(ical).c_coor2_size = 
     +  emcal_par(ical).ylimit(2) - emcal_par(ical).ylimit(1)
        emcal_par(ical).siga_em = 0.
        emcal_par(ical).sigb_em = 0.
        emcal_par(ical).siga_had = 0.
        emcal_par(ical).sigb_had = 0.
        emcal_par(ical).em_had_ratio = 1.
        emcal_par(ical).zerosup  = 0.001
        write(mcp_llpt,'(a,4f9.3)') '   Absorber '//
     +  emcal_par(ical).name(:lenocc(emcal_par(ical).name))//
     +  ' in/active'//
     +  AbsorberBox(k).material(:lenocc(AbsorberBox(k).material))
     +  //' '//
     +  AbsorberBox(k).material(:lenocc(AbsorberBox(k).material))//
     +  ' zmin, zmax',
     +  emcal_par(ical).zmin,emcal_par(ical).zmax
       endif
  100 enddo

      end        

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.8  1998/02/19 19:45:21  bphyslib
c fix typo
c
c Revision 1.7  1997/04/04  20:29:47  garren
c add rcs log line
c
