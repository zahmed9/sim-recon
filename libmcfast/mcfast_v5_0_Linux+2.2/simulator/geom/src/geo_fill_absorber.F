c
      subroutine geo_fill_absorber
     &           (keyword,nstart,i_fill,buffer,char_name)
c
      implicit none
c
#include "const.inc"
#include "mcp_luns.inc"
#include "absorber.inc"
#include "emcal.inc"
#include "material.inc"

      character*(*) keyword
      integer nstart
      integer i_fill
      real buffer(*)
      character*(*) char_name
c
c
      integer num_abs
      integer i, mat
      character*40 name, shape
      real rmin(2), rmax(2), zmin, zmax, xlimit(2), ylimit(2)
      real xlimit_gap(2), ylimit_gap(2)
      integer type
      real eta_min, eta_max, theta_min, theta_max
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      num_abs = absorber_num
c
      if (nstart .eq. 1) then
       num_abs = num_abs + 1
      end if
c
      if (num_abs .gt. max_absorber) num_abs = max_absorber
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        name = char_name
       end if
       if (nstart .eq. 2) then
        shape = char_name
       end if
       if ((keyword.eq.'ABSORBER'.and.nstart .eq. 10) .or.
     *      (keyword.eq.'ABSORBERBOX'.and.nstart.eq.14)) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          mat = i
          goto 100
         end if
        end do
  100   if (mat .le. 0 .or. mat .gt. mtl_num) then
         write(mcp_llpt, 5000) num_abs
        end if
       end if
      end if

      if (keyword .eq. 'ABSORBERBOX') goto 300

      if (i_fill .gt. 0) then

       type = int(buffer(4))
       rmin(1) = buffer( 5)
       rmin(2) = buffer( 6)
       rmax(1) = buffer( 7)
       rmax(2) = buffer( 8)
       zmin    = buffer( 9) - buffer(10) / 2.
       zmax    = buffer( 9) + buffer(10) / 2.

       if (mod(type,10) .eq. 1) then
        if (zmin .ge. zmax .or. 
     *      rmin(1) .ge. rmax(1) .or.
     *      rmin(2) .ge. rmax(2)) then
          write(mcp_llpt,5551) num_abs
          goto 200
        endif
       endif
c
       if (mod(type,10) .eq. 2) then
        if (zmin .gt. zmax) then
         write(mcp_llpt,5552) zmin, zmax
         goto 200
        endif
        if (zmin .le. 0. .and. zmax .ge. 0) then
         write(mcp_llpt,5552) zmin, zmax
         goto 200
        endif
       end if

c
c     Calculate eta_min & eta_max
c
       call geteta(type,rmin,rmax,zmin,zmax,eta_min,eta_max)

       if (type .gt. 10) then
        absorber_par(num_abs).name    = name
        absorber_par(num_abs).shape   = shape
        absorber_par(num_abs).material= mat
        absorber_par(num_abs).type    = type
        absorber_par(num_abs).rmin(1) = rmin(1)
        absorber_par(num_abs).rmin(2) = rmin(2)
        absorber_par(num_abs).rmax(1) = rmax(1)
        absorber_par(num_abs).rmax(2) = rmax(2)
        absorber_par(num_abs).zmin    = zmin
        absorber_par(num_abs).zmax    = zmax
        absorber_par(num_abs).eta_min = eta_min
        absorber_par(num_abs).eta_max = eta_max
       else
        emcal_num = emcal_num + 1
        emcal_par(emcal_num).name = name
        emcal_par(emcal_num).shape = shape
        emcal_par(emcal_num).material = mat
        emcal_par(emcal_num).active_material = mat
        emcal_par(emcal_num).type = type
        emcal_par(emcal_num).seg_type = 0
        emcal_par(emcal_num).rmin(1) = rmin(1)
        emcal_par(emcal_num).rmin(2) = rmin(2)
        emcal_par(emcal_num).rmax(1) = rmax(1)
        emcal_par(emcal_num).rmax(2) = rmax(2)
        emcal_par(emcal_num).zmin = zmin
        emcal_par(emcal_num).zmax = zmax
        emcal_par(emcal_num).eta_min = eta_min
        emcal_par(emcal_num).eta_max = eta_max 
        emcal_par(emcal_num).ncoor1  = 1
        emcal_par(emcal_num).ncoor2  = 1
        emcal_par(emcal_num).c_coor1_size = 2.*pi
        emcal_par(emcal_num).c_coor2_size = eta_max-eta_min
        emcal_par(emcal_num).siga_em = 0.
        emcal_par(emcal_num).sigb_em = 0.
        emcal_par(emcal_num).siga_had = 0.
        emcal_par(emcal_num).sigb_had = 0.
        emcal_par(emcal_num).em_had_ratio = 1.
        emcal_par(emcal_num).zerosup  = 0.001
        emcal_par(emcal_num).seg_type = 0
       end if

       write(mcp_llpt,6000) num_abs,zmin,zmax,eta_min,eta_max

      end if

      if (type .gt. 10) then
       absorber_num = num_abs
      end if

  200 return

c     BOX-shaped Absorbers
  300 if (i_fill .gt. 0) then

       type = int(buffer(4))
       if (mod(type,10) .eq. 1) then
        write(6,*) 'No Central BOX-shaped Absorbers, type changed'
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
        write(6,*) 'No Central BOX-shaped Absorbers, ',
     *              'skip because of Z-range !'
        return
       end if

       if (type .gt. 10) then
        absorber_par(num_abs).type    = type
        absorber_par(num_abs).name    = name
        absorber_par(num_abs).shape   = shape
        absorber_par(num_abs).material= mat
        absorber_par(num_abs).xlimit(1) = xlimit(1)
        absorber_par(num_abs).xlimit(2) = xlimit(2)
        absorber_par(num_abs).ylimit(1) = ylimit(1)
        absorber_par(num_abs).ylimit(2) = ylimit(2)
        absorber_par(num_abs).xlimit_gap(1) = xlimit_gap(1)
        absorber_par(num_abs).xlimit_gap(2) = xlimit_gap(2)
        absorber_par(num_abs).ylimit_gap(1) = ylimit_gap(1)
        absorber_par(num_abs).ylimit_gap(2) = ylimit_gap(2)
        absorber_par(num_abs).zmin    = zmin
        absorber_par(num_abs).zmax    = zmax
       else
        emcal_num = emcal_num + 1
        emcal_par(emcal_num).type = type
        emcal_par(emcal_num).name = name
        emcal_par(emcal_num).shape = shape
        emcal_par(emcal_num).material = mat
        emcal_par(emcal_num).active_material = mat
        emcal_par(emcal_num).seg_type = 0
        emcal_par(emcal_num).xlimit(1) = xlimit(1)
        emcal_par(emcal_num).xlimit(2) = xlimit(2)
        emcal_par(emcal_num).ylimit(1) = ylimit(1)
        emcal_par(emcal_num).ylimit(2) = ylimit(2)
        emcal_par(emcal_num).xlimit_gap(1) = xlimit_gap(1)
        emcal_par(emcal_num).xlimit_gap(2) = xlimit_gap(2)
        emcal_par(emcal_num).ylimit_gap(1) = ylimit_gap(1)
        emcal_par(emcal_num).ylimit_gap(2) = ylimit_gap(2)
        emcal_par(emcal_num).zmin = zmin
        emcal_par(emcal_num).zmax = zmax
        emcal_par(emcal_num).ncoor1  = 1
        emcal_par(emcal_num).ncoor2  = 1
        emcal_par(emcal_num).c_coor1_size = 
     *  emcal_par(emcal_num).xlimit(2)-emcal_par(emcal_num).xlimit(1)
        emcal_par(emcal_num).c_coor2_size = 
     *  emcal_par(emcal_num).ylimit(2)-emcal_par(emcal_num).ylimit(1)
        emcal_par(emcal_num).siga_em = 0.
        emcal_par(emcal_num).sigb_em = 0.
        emcal_par(emcal_num).siga_had = 0.
        emcal_par(emcal_num).sigb_had = 0.
        emcal_par(emcal_num).em_had_ratio = 1.
       end if

       write(mcp_llpt,6000) num_abs,zmin,zmax,eta_min,eta_max

      end if

      if (type .gt. 10) then
       absorber_num = num_abs
      end if
      return

 5000 format(' ABSORBER ', i4, ' : UNKNOWN MATERIAL ')
 5551 format(' ABSORBER: ', i4, ' BARREL GEOMETRY ERROR' )
 5552 format(' ABSORBER: Forward geometry error, 
     *         zmin,zmax: ', 2f10.3)
 6000 format(' ABSORBERGEOM: abs_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:21  eugenio
c Initial revision
c
c Revision 1.6  1997/04/04 20:29:33  garren
c add rcs log line
c
