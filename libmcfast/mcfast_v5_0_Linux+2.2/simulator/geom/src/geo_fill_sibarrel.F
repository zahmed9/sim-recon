      subroutine geo_fill_sibarrel(keyword,i_fill,buffer,char_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
#include "si_barrel.inc"
#include "const.inc"
c
      character*(*) keyword
c
      integer nstart, i_fill
c
      real buffer(*)
c
      character*(*) char_name
c
      integer num_sib
      integer i
      integer i_det, i_lyr, i_waf
      integer id_mat
      integer nchan, nstrip
      real beta, dbeta
      real delta, dmax
      real stereo, cos_stereo, sin_stereo
      real phi_waf, z_waf, alpha_cr
c
      character*4 speci
      save speci
c
c
c
      i_det   = 0
      i_lyr   = 0
      id_mat  = 0
      nchan   = 0
c
c
c
      if (keyword .eq. 'SIBARREL') then
c
       num_sib = int(buffer(2))
c
       if (num_sib .gt. max_sib) num_sib = max_sib
c
       if (i_fill .eq. 0) then
        if (char_name .ne. ' ') then
         sib_num = sib_num + 1
         sib_par(num_sib).name = char_name
        end if
       else
        sib_par(num_sib).numlyr = int(buffer(4))
        if (sib_par(num_sib).numlyr .gt. max_sib_lyr) then
         sib_par(num_sib).numlyr = max_sib_lyr
        end if
        if (sib_par(num_sib).z .ne. buffer(5)) then
         if (sib_par(num_sib).numlyr .gt. 0) then
          do i = 1,sib_par(num_sib).numlyr
           sib_par(num_sib).lyr(i).plane(1).zmin =
     &     sib_par(num_sib).lyr(i).plane(1).zmin + buffer(5)
           sib_par(num_sib).lyr(i).plane(1).zmax =
     &     sib_par(num_sib).lyr(i).plane(1).zmax + buffer(5)
           if (sib_par(num_sib).lyr(i).numplane .gt. max_sib_plane) 
     &         sib_par(num_sib).lyr(i).numplane = max_sib_plane
           if (sib_par(num_sib).lyr(i).numplane .gt. 0) then
            do i_waf = 1,sib_par(num_sib).lyr(i).numplane
             sib_par(num_sib).lyr(i).plane(i_waf).zmin = 
     &           sib_par(num_sib).lyr(i).plane(1).zmin
             sib_par(num_sib).lyr(i).plane(i_waf).zmax = 
     &           sib_par(num_sib).lyr(i).plane(1).zmax
            end do
           end if
          end do
         end if
        end if
        sib_par(num_sib).z      = buffer(5)
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERSIB') then
c
       i_det = int(buffer(2))
       if (i_det .gt. max_sib) i_det = max_sib
       i_lyr = int(buffer(3))
       if (i_lyr .gt. max_sib_lyr) i_lyr = max_sib_lyr
c
       if (char_name .ne. ' ') then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then         
          id_mat = i
          goto 100
         end if
        end do
  100   if (id_mat .le. 0 .or. id_mat .gt. mtl_num) then
         write(mcp_llpt,5000) i_det, i_lyr
         stop
        end if
        if (i_det .gt. 0 .and. i_lyr .gt. 0) then
         sib_par(i_det).lyr(i_lyr).plane(1).material = id_mat
        end if
       end if
c
       if (i_fill .eq. 1) then
c
        sib_par(i_det).lyr(i_lyr).numplane = int(buffer(5))
        if (sib_par(i_det).lyr(i_lyr).numplane .gt. max_sib_plane) 
     &      sib_par(i_det).lyr(i_lyr).numplane = max_sib_plane
c
        sib_par(i_det).lyr(i_lyr).plane(1).zmin = 
     &      sib_par(i_det).z - buffer(6) / 2.
        sib_par(i_det).lyr(i_lyr).plane(1).zmax = 
     &      sib_par(i_det).z + buffer(6) / 2.
        sib_par(i_det).lyr(i_lyr).plane(1).beta = buffer(7)
        delta = buffer(8)
        sib_par(i_det).lyr(i_lyr).plane(1).delta_min = delta
        sib_par(i_det).lyr(i_lyr).plane(1).thick = buffer(9)
        sib_par(i_det).lyr(i_lyr).plane(1).dmin = -buffer(10)/2.
        sib_par(i_det).lyr(i_lyr).plane(1).dmax =  buffer(10)/2.
        sib_par(i_det).lyr(i_lyr).plane(1).delta_max =
     &      sqrt(delta**2 + buffer(10)**2 / 4.)
        sib_par(i_det).lyr(i_lyr).plane(1).type = int(buffer(11))
c
        dbeta = tpi / sib_par(i_det).lyr(i_lyr).numplane
c
        if (sib_par(i_det).lyr(i_lyr).numplane .gt. 0) then
        do i_waf = 1,sib_par(i_det).lyr(i_lyr).numplane
         sib_par(i_det).lyr(i_lyr).plane(i_waf).material  =
     &       sib_par(i_det).lyr(i_lyr).plane(1).material
         sib_par(i_det).lyr(i_lyr).plane(i_waf).zmin      = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).zmin    
         sib_par(i_det).lyr(i_lyr).plane(i_waf).zmax      = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).zmax    
         sib_par(i_det).lyr(i_lyr).plane(i_waf).dmin      = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).dmin    
         sib_par(i_det).lyr(i_lyr).plane(i_waf).dmax      = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).dmax    
         sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_min = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).delta_min
         sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_max = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).delta_max
         sib_par(i_det).lyr(i_lyr).plane(i_waf).thick     = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).thick
         sib_par(i_det).lyr(i_lyr).plane(i_waf).type      = 
     &       sib_par(i_det).lyr(i_lyr).plane(1).type
         beta = sib_par(i_det).lyr(i_lyr).plane(1).beta 
     &        + dbeta * (i_waf - 1)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).beta    = beta
         sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(1)  = cos(beta)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(2)  = sin(beta)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(3)  = 0.
         sib_par(i_det).lyr(i_lyr).plane(i_waf).xpos(1) = 
     &       delta * cos(beta)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).xpos(2) = 
     &       delta * sin(beta)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).xpos(3) = 
     &       sib_par(i_det).z
        end do
        end if
c
       end if
c
      end if
c
c
c
      if (keyword .eq. 'WAFER') then
c
       if (i_fill .eq. 0) then
        if (char_name .ne. ' ') then
         speci = char_name
        end if
       end if
c
       if (i_fill .gt. 0) then
        i_det = int(buffer(3))
        if (i_det .gt. max_sib) i_det = max_sib
        i_lyr = int(buffer(4))
        if (i_lyr .gt. max_sib) i_lyr = max_sib_lyr
c
        if (speci .eq. 'ALL') then
c
         if (sib_par(i_det).lyr(i_lyr).numplane .gt. max_sib_plane)
     &       sib_par(i_det).lyr(i_lyr).numplane = max_sib_plane
         stereo = buffer(10)
         cos_stereo = cos(stereo)
         sin_stereo = sin(stereo)
c
         phi_waf = 2. * abs(buffer(7))
         z_waf   = 2. * abs(buffer(8))
         if (phi_waf .gt. 0. .and. z_waf .gt. 0.) then
c
cc          alpha_cr = atan(phi_waf/z_waf)
cc          if (abs(stereo) .le. alpha_cr) then
cc           nstrip = z_waf / ( buffer(9) * cos_stereo )
cc          else if (abs(stereo) .gt. alpha_cr .and. 
cc     &             abs(stereo) .le. pi/4) then
cc           nstrip = phi_waf / ( buffer(9) * sin_stereo )
cc          end if
c
          if (sib_par(i_det).lyr(i_lyr).plane(1).type 
     &        .eq. 1) then
           nstrip = phi_waf / buffer(9)
          else if (sib_par(i_det).lyr(i_lyr).plane(1).type 
     &             .eq. 2) then
           nstrip = z_waf / buffer(9)
          end if
          if (nstrip .lt. int(buffer(6)) ) then
           write(mcp_llpt,6000) i_det, i_lyr, nstrip
           buffer(6) = float(nstrip)
          end if
c
         end if
c
         sib_par(i_det).nchan = sib_par(i_det).nchan 
     &                        - sib_par(i_det).lyr(i_lyr).nchan
c
         if (sib_par(i_det).lyr(i_lyr).numplane .gt. 0) then
          do i_waf = 1,sib_par(i_det).lyr(i_lyr).numplane
           sib_par(i_det).lyr(i_lyr).plane(i_waf).tilt = buffer(5)
           if (buffer(5) .ne. 0.0) then
             beta = sib_par(i_det).lyr(i_lyr).plane(i_waf).beta
     *          + buffer(5)
             sib_par(i_det).lyr(i_lyr).plane(i_waf).beta = beta
             sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(1) = cos(beta)
             sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(2) = sin(beta)
             sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(3) = 0.
             delta = sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_min
             dmax = sib_par(i_det).lyr(i_lyr).plane(i_waf).dmax
             sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_min = 
     &            sqrt((delta - dmax * sin(buffer(5)))**2 +
     &                   (dmax * cos(buffer(5)))**2)
             sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_max = 
     &            sqrt((delta + dmax * sin(buffer(5)))**2 + 
     &                   (dmax * cos(buffer(5)))**2)
           endif
           nchan = nchan + int(buffer(6))
           sib_par(i_det).lyr(i_lyr).plane(i_waf).nstrip   = 
     &         int(buffer(6))
           sib_par(i_det).lyr(i_lyr).plane(i_waf).nchan    = 
     &         int(buffer(6))
           sib_par(i_det).lyr(i_lyr).plane(i_waf).coord0_x = 
     &         buffer(7)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).coord0_y = 
     &         buffer(8)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).chan0    = 0
           sib_par(i_det).lyr(i_lyr).plane(i_waf).pitch    = 
     &         buffer(9)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).stereo = stereo
           sib_par(i_det).lyr(i_lyr).plane(i_waf).cos_stereo = 
     &         cos_stereo
           sib_par(i_det).lyr(i_lyr).plane(i_waf).sin_stereo = 
     &         sin_stereo
           sib_par(i_det).lyr(i_lyr).plane(i_waf).eff_hit = 
     &         buffer(11)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).siga = buffer(12)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).sigb = buffer(13)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).sigc = buffer(14)
          end do
          sib_par(i_det).lyr(i_lyr).nchan = nchan
          sib_par(i_det).nchan = sib_par(i_det).nchan
     &                         + sib_par(i_det).lyr(i_lyr).nchan
         end if
c
        else if (speci .eq. 'SPC') then
c
         i_waf = int(buffer(5))
         if (i_waf .gt. max_sib_plane) i_waf = max_sib_plane
c
         sib_par(i_det).lyr(i_lyr).plane(i_waf).tilt = buffer(6)
         if (buffer(6) .ne. 0.0) then
           beta = sib_par(i_det).lyr(i_lyr).plane(i_waf).beta
     *          + buffer(5)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).beta = beta
           sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(1) = cos(beta)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(2) = sin(beta)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).eta(3) = 0.
           delta = sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_min
           dmax = sib_par(i_det).lyr(i_lyr).plane(i_waf).dmax
           sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_min = 
     &          sqrt((delta - dmax * sin(buffer(6)))**2 + 
     &                   (dmax * cos(buffer(6)))**2)
           sib_par(i_det).lyr(i_lyr).plane(i_waf).delta_max = 
     &          sqrt((delta + dmax * sin(buffer(6)))**2 + 
     &                   (dmax * cos(buffer(6)))**2)
         endif
c
         phi_waf = 2. * abs(buffer(8))
         z_waf   = 2. * abs(buffer(9))
         if (phi_waf .gt. 0. .and. z_waf .gt. 0.) then
c
cc          alpha_cr = atan(phi_waf/z_waf)
cc          if ( abs(buffer(11)) .le. alpha_cr ) then
cc           nstrip = z_waf / ( buffer(10) * cos(buffer(11)) )
cc          else if (abs(buffer(11)) .gt. alpha_cr .and. 
cc     &             abs(buffer(11)) .le. pi/4) then
cc           nstrip = phi_waf / ( buffer(10) * sin(buffer(11)) )
cc          end if
c
          if (sib_par(i_det).lyr(i_lyr).plane(i_waf).type 
     &        .eq. 1) then
           nstrip = phi_waf / buffer(10)
          else if (sib_par(i_det).lyr(i_lyr).plane(i_waf).type 
     &             .eq. 2) then
           nstrip = z_waf / buffer(10)
          end if
          if (nstrip .lt. int(buffer(7)) ) then
           write(mcp_llpt,6001) i_det, i_lyr, i_waf, nstrip
           buffer(7) = float(nstrip)
          end if
c
         end if
c
         sib_par(i_det).nchan = sib_par(i_det).nchan
     &   - sib_par(i_det).lyr(i_lyr).plane(i_waf).nchan
         sib_par(i_det).lyr(i_lyr).nchan = 
     &       sib_par(i_det).lyr(i_lyr).nchan
     &    -  sib_par(i_det).lyr(i_lyr).plane(i_waf).nchan
         sib_par(i_det).lyr(i_lyr).plane(i_waf).nstrip = 
     &       int(buffer(7))
         sib_par(i_det).lyr(i_lyr).nchan = 
     &       sib_par(i_det).lyr(i_lyr).nchan
     &     + int(buffer(7))
         sib_par(i_det).nchan = sib_par(i_det).nchan 
     &                        + int(buffer(7))
c
         sib_par(i_det).lyr(i_lyr).plane(i_waf).coord0_x = buffer(8)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).coord0_x = buffer(9)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).pitch  = buffer(10)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).stereo = buffer(11)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).cos_stereo = 
     &       cos(buffer(11))
         sib_par(i_det).lyr(i_lyr).plane(i_waf).sin_stereo = 
     &       sin(buffer(11))
         sib_par(i_det).lyr(i_lyr).plane(i_waf).eff_hit = buffer(12)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).siga = buffer(13)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).sigb = buffer(14)
         sib_par(i_det).lyr(i_lyr).plane(i_waf).sigc = buffer(15)
c
        end if        
c
       end if
c
      end if
c
c
c
      return
c
 5000 format('SI BARREL ', i4, ' ERROR : NO MATERIAL FOR LAYER ', i4)
 6000 format('SI BARREL ', i4, ' LAYER ', i4,' :', /,
     &       ' max number of strips on plane can not exceed ', i8)
 6001 format('SI BARREL ', i4, ' LAYER ', i4, ' WAFER ', i4, ' :', /,
     &       ' max number of strips on plane can not exceed ', i8)
c
      end


c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:39  garren
c add rcs log line
c
