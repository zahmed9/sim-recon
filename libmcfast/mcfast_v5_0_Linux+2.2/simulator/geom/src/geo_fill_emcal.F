c
      subroutine geo_fill_emcal
     &           (keyword,nstart,i_fill,buffer,char_name)
c    modified May 96, Amber Boehnlein--changed emcal structure
c
      implicit none
c
      character*(*) keyword
c
      integer nstart
c
      integer i_fill
c
      real buffer(*)
c
      character*(*) char_name
c
#include "const.inc"
#include "mcp_luns.inc"
#include "emcal.inc"
#include "material.inc"
c
      integer num_emc
      integer i
      real rmin(2), rmax(2), 
     *     xlimit(2), ylimit(2), xlimit_gap(2), ylimit_gap(2),
     *     zmin, zmax
      integer type, nlayers
      real eta_min, eta_max, theta_min, theta_max
      real eta, theta, phi, deleta, delphi
      integer ncoor1, ncoor2
      real siga_em, sigb_em, siga_had, sigb_had, em_had_ratio
c
      num_emc = emcal_num
c
      if (nstart .eq. 1) then
       num_emc = num_emc + 1
      end if
c
      if (num_emc .gt. max_emcal) then
       num_emc = max_emcal
       return
      end if
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        emcal_par(num_emc).name = char_name
       end if
       if (nstart .eq. 2) then
        emcal_par(num_emc).shape = char_name
       end if
       if ( (keyword.eq.'EMCALORIMETER'.and.nstart.eq.10) .or.
     *     (keyword.eq.'CALORBOX'.and.nstart.eq.14) ) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          emcal_par(num_emc).material = i
          goto 100
         end if
        end do
  100   if (emcal_par(num_emc).material .le. 0 .or.
     &      emcal_par(num_emc).material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_emc
        end if
       end if
       if ( (keyword.eq.'EMCALORIMETER'.and.nstart.eq.11) .or.
     *     (keyword.eq.'CALORBOX'.and.nstart.eq.15) ) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          emcal_par(num_emc).active_material = i
          goto 101
         end if
        end do
  101   if (emcal_par(num_emc).active_material .le. 0 .or.
     &      emcal_par(num_emc).active_material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_emc
        end if
       end if
      end if
c
      if (keyword .eq. 'CALORBOX') goto 300
c
      if (i_fill .gt. 0) then
c
       type = int(buffer(4))
       rmin(1) = buffer( 5)
       rmin(2) = buffer( 6)
       rmax(1) = buffer( 7)
       rmax(2) = buffer( 8)
       zmin    = buffer( 9) - buffer(10) / 2.
       zmax    = buffer( 9) + buffer(10) / 2.
       ncoor1    = int(buffer(13))
       if (ncoor1 .gt. max_ncoor1) then
         write(6,*) "Finer x or phi segmentation than allowed, ",
     *         "truncating ncoor1"
         ncoor1 = max_ncoor1
       endif
       ncoor2    = int(buffer(14))
       if (ncoor2 .gt. max_ncoor2) then
         write(6,*) "Finer y or eta segmentation than allowed, ",
     *         "truncating ncoor2"
         ncoor2 = max_ncoor2
       endif
       siga_em = buffer(15)
       sigb_em = buffer(16)
       siga_had= buffer(17)
       sigb_had= buffer(18)
       em_had_ratio = buffer(19)
       nlayers = buffer(20)
       if (nlayers .lt. 1) nlayers = 1

       if (type .eq. 1) then
        if (zmin .ge. zmax .or. 
     *      rmin(1) .ge. rmax(1) .or.
     *      rmin(2) .ge. rmax(2)) then
          write(mcp_llpt,5551) num_emc
          goto 200
        endif
       endif
c
       if (type .eq. 2) then
        if (zmin .gt. zmax) then
         write(mcp_llpt,5552) zmin, zmax
         goto 200
        endif
        if (zmin .le. 0. .and. zmax .ge. 0) then
         write(mcp_llpt,5552) zmin, zmax
         goto 200
        endif
       end if

       emcal_par(num_emc).type    = type
       emcal_par(num_emc).seg_type = 0
       emcal_par(num_emc).rmin(1) = rmin(1)
       emcal_par(num_emc).rmin(2) = rmin(2)
       emcal_par(num_emc).rmax(1) = rmax(1)
       emcal_par(num_emc).rmax(2) = rmax(2)
       emcal_par(num_emc).zmin    = zmin
       emcal_par(num_emc).zmax    = zmax
       emcal_par(num_emc).ncoor1    = ncoor1
       emcal_par(num_emc).ncoor2    = ncoor2
       emcal_par(num_emc).siga_em = siga_em
       emcal_par(num_emc).sigb_em = sigb_em
       emcal_par(num_emc).siga_had= siga_had
       emcal_par(num_emc).sigb_had= sigb_had
       emcal_par(num_emc).em_had_ratio = em_had_ratio
       emcal_par(num_emc).zerosup = 0.1
c
c     Calculate eta_min & eta_max
c
       call geteta(type,rmin,rmax,zmin,zmax,eta_min, eta_max)
c
       emcal_par(num_emc).eta_min = eta_min
       emcal_par(num_emc).eta_max = eta_max
c
c   Calculate some values for the hit part
c
       deleta = (eta_max-eta_min)/float(ncoor2)
       delphi = (2.*pi)/float(ncoor1)
       emcal_par(num_emc).c_coor2_size = deleta
       emcal_par(num_emc).c_coor1_size = delphi

       write(mcp_llpt,6000) num_emc,zmin,zmax,eta_min,eta_max

      end if

      emcal_num = num_emc

  200 return

  300 if (i_fill .gt. 0) then

       type = int(buffer(4))

       if (mod(type,100) .eq. 1) then
        write(6,*) 'No Central BOX-shaped CALs, change type to FORWARD'
        type = type + 1
       end if

       xlimit(1) = buffer( 5)
       xlimit(2) = buffer( 6)
       ylimit(1) = buffer( 7)
       ylimit(2) = buffer( 8)
       xlimit_gap(1) = buffer( 9)
       xlimit_gap(2) = buffer(10)
       ylimit_gap(1) = buffer(11)
       ylimit_gap(2) = buffer(12)
       zmin    = buffer(13) - buffer(14) / 2.
       zmax    = buffer(13) + buffer(14) / 2.

       if (zmin .lt. 0. .and. zmax .gt. 0.) then
        write(6,*) 
     *    'No Central BOX-shaped CALs, skip because of Z-range !'
        return
       end if

       ncoor1    = int(buffer(17))
       if (ncoor1 .gt. max_ncoor1) then
         write(6,*) "Finer x or phi segmentation than allowed, ",
     *             "truncating ncoor1"
         ncoor1 = max_ncoor1
       endif
       ncoor2    = int(buffer(18))
       if (ncoor2 .gt. max_ncoor2) then
         write(6,*) "Finer y or eta segmentation than allowed, ",
     *    "truncating ncoor2"
         ncoor2 = max_ncoor2
       endif
       siga_em = buffer(19)
       sigb_em = buffer(20)
       siga_had= buffer(21)
       sigb_had= buffer(22)
       em_had_ratio = buffer(23)
       nlayers = buffer(24)
       if (nlayers .lt. 1) nlayers = 1

       emcal_par(num_emc).type    = type
       emcal_par(num_emc).seg_type = 1
       emcal_par(num_emc).xlimit(1) = xlimit(1)
       emcal_par(num_emc).xlimit(2) = xlimit(2)
       emcal_par(num_emc).ylimit(1) = ylimit(1)
       emcal_par(num_emc).ylimit(2) = ylimit(2)
       emcal_par(num_emc).xlimit_gap(1) = xlimit_gap(1)
       emcal_par(num_emc).xlimit_gap(2) = xlimit_gap(2)
       emcal_par(num_emc).ylimit_gap(1) = ylimit_gap(1)
       emcal_par(num_emc).ylimit_gap(2) = ylimit_gap(2)
       emcal_par(num_emc).zmin    = zmin
       emcal_par(num_emc).zmax    = zmax
       emcal_par(num_emc).ncoor1  = ncoor1
       emcal_par(num_emc).ncoor2  = ncoor2
       emcal_par(num_emc).siga_em = siga_em
       emcal_par(num_emc).sigb_em = sigb_em
       emcal_par(num_emc).siga_had= siga_had
       emcal_par(num_emc).sigb_had= sigb_had
       emcal_par(num_emc).em_had_ratio = em_had_ratio
       emcal_par(num_emc).zerosup = 0.1
       emcal_par(num_emc).nlayers = nlayers
c
c   Calculate some values for the hit part
c
       emcal_par(num_emc).c_coor1_size = 
     * (emcal_par(num_emc).xlimit(2)-emcal_par(num_emc).xlimit(1))
     * / emcal_par(num_emc).ncoor1
       emcal_par(num_emc).c_coor2_size = 
     * (emcal_par(num_emc).ylimit(2)-emcal_par(num_emc).ylimit(1))
     * / emcal_par(num_emc).ncoor2

       write(mcp_llpt,6000) num_emc,zmin,zmax

      end if

      emcal_num = num_emc

      return

 5000 format(' EM Cal.: ', i4, ' : UNKNOWN MATERIAL ')
 5551 format(' EM Cal.: ', i4, ' BARREL GEOMETRY ERROR' )
 5552 format(' EM Cal.: Forward geometry error, 
     *         zmin,zmax: ', 2f10.3)
 6000 format(' EM Cal. GEOM: emc_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.11  1997/08/26 17:14:17  bphyslib
c remove extraneous comma
c
c Revision 1.10  1997/04/04  20:29:35  garren
c add rcs log line
c
