      subroutine geo_fill_ftrk(keyword,nstart,i_fill,buffer,char_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
#include "for_trk.inc"
c
      character*(*) keyword
c
      integer nstart, i_fill
c
      real buffer(*)
c
      character*(*) char_name
c
      integer num_ftrk
      integer i
      integer boundry
      integer i_det, i_lyr
      integer id_mat
      integer nchan
      real z_center_global, zmin, zmax, z_length, thick_total
      real xdim, ydim, alpha_cr, cell_size
c
c
c
      i_det   = 0
      i_lyr   = 0
      id_mat  = 0
      nchan   = 0
      z_center_global = 0.
      zmin    = 0.
      zmax    = 0.
      thick_total = 0.
c
c
c
      if (keyword .eq. 'FORTRACKING') then
c
      num_ftrk = int(buffer(2))
c
      if (num_ftrk .gt. max_ftrk) num_ftrk = max_ftrk
c
       if (i_fill .eq. 0) then
c
        if (char_name .ne. ' ') then
c
         if (nstart .eq. 2) then
          ftrk_num = ftrk_num + 1
          ftrk_par(num_ftrk).name = char_name
         end if
         if (nstart .eq. 10) then
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            ftrk_par(num_ftrk).material = i
            goto 100
           end if
          end do
  100     if (ftrk_par(num_ftrk).material .le. 0 .or.
     &        ftrk_par(num_ftrk).material .gt. mtl_num) then
           write(mcp_llpt,5000) num_ftrk
          end if
         end if
         if (nstart .gt. 16) then
          boundry = nstart - 16
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            ftrk_par(num_ftrk).mat_boun(boundry) = i
            goto 200
           end if
          end do
  200     if (ftrk_par(num_ftrk).mat_boun(boundry).le.0.or.
     &        ftrk_par(num_ftrk).mat_boun(boundry).gt.mtl_num) then
           write(mcp_llpt,5001) num_ftrk, boundry
          end if
         end if
c
        end if
c
       end if
c
       if (i_fill .gt. 0) then
        ftrk_par(num_ftrk).nlyr = int(buffer(4))
        if (ftrk_par(num_ftrk).nlyr .gt. max_ftrk_lyr) then
         ftrk_par(num_ftrk).nlyr = max_ftrk_lyr
        end if
        ftrk_par(num_ftrk).xmin = buffer( 5)
        ftrk_par(num_ftrk).xmax = buffer( 6)
        ftrk_par(num_ftrk).ymin = buffer( 7)
        ftrk_par(num_ftrk).ymax = buffer( 8)
        z_center_global         = buffer( 9) 
        zmin = z_center_global - buffer(10) / 2.
        zmax = z_center_global + buffer(10) / 2.
c
        if (ftrk_par(num_ftrk).nlyr .gt. 0) then
c
         do i = 1,ftrk_par(num_ftrk).nlyr
c
          if (ftrk_par(num_ftrk).zmin .ne. zmin .or.
     &        ftrk_par(num_ftrk).zmax .ne. zmax) then
           ftrk_par(num_ftrk).lyr(i).z =
     &     ftrk_par(num_ftrk).lyr(i).z + z_center_global
          end if
c
          if (ftrk_par(num_ftrk).lyr(i).eff_hit .eq. 0.) then
            ftrk_par(num_ftrk).lyr(i).eff_hit = buffer(24)
          end if
          if (ftrk_par(num_ftrk).lyr(i).siga .eq. 0.) then
            ftrk_par(num_ftrk).lyr(i).siga = buffer(25)
          end if
          if (ftrk_par(num_ftrk).lyr(i).sigb .eq. 0.) then
            ftrk_par(num_ftrk).lyr(i).sigb = buffer(26)
          end if
          if (ftrk_par(num_ftrk).lyr(i).sigc .eq. 0.) then
            ftrk_par(num_ftrk).lyr(i).sigc = buffer(27)
          end if
          thick_total = thick_total 
     &                + ftrk_par(num_ftrk).lyr(i).thickness
c
         end do
c
        end if
        if (thick_total .gt. buffer(10)) then
         write(mcp_llpt,6000) num_ftrk, 
     &                        thick_total, 
     &                        int(buffer(4)),
     &                        buffer(10)
         stop
        end if
        ftrk_par(num_ftrk).zmin = zmin
        ftrk_par(num_ftrk).zmax = zmax
        do i = 1,6
         ftrk_par(num_ftrk).thick_boun(i) = buffer(11+i)
        end do
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERFTRK') then
c
       i_det = int(buffer(2))
       i_lyr = int(buffer(3))
       if (i_det .gt. max_ftrk) i_det = max_ftrk
       if (i_lyr .gt. max_ftrk_lyr) i_lyr = max_ftrk_lyr
c
       if (i_fill .gt. 0) then
c
        ftrk_par(i_det).lyr(i_lyr).xmin = buffer(6)
        ftrk_par(i_det).lyr(i_lyr).xmax = buffer(7)
        ftrk_par(i_det).lyr(i_lyr).xmin_gap = buffer(8)
        ftrk_par(i_det).lyr(i_lyr).xmax_gap = buffer(9)
        ftrk_par(i_det).lyr(i_lyr).ymin = buffer(10)
        ftrk_par(i_det).lyr(i_lyr).ymax = buffer(11)
        ftrk_par(i_det).lyr(i_lyr).ymin_gap = buffer(12)
        ftrk_par(i_det).lyr(i_lyr).ymax_gap = buffer(13)
        z_center_global =
     &  (ftrk_par(i_det).zmin +
     &   ftrk_par(i_det).zmax) / 2.
        ftrk_par(i_det).lyr(i_lyr).z = buffer( 4) 
     &                               + z_center_global
        ftrk_par(i_det).lyr(i_lyr).thickness  = buffer(5)
        ftrk_par(i_det).lyr(i_lyr).stereo     = buffer(14)
        ftrk_par(i_det).lyr(i_lyr).cos_stereo = cos(buffer(14))
        ftrk_par(i_det).lyr(i_lyr).sin_stereo = sin(buffer(14))
        nchan = ftrk_par(i_det).nchan 
     &        - ftrk_par(i_det).lyr(i_lyr).ncell 
     &        + int(buffer(15))
        ftrk_par(i_det).lyr(i_lyr).ncell    = int(buffer(15))
        ftrk_par(i_det).lyr(i_lyr).coord0_x = buffer(16)
        ftrk_par(i_det).lyr(i_lyr).coord0_y = buffer(17)
c
c   Calculate cell size
c
        xdim = 2*abs(ftrk_par(i_det).lyr(i_lyr).coord0_x)
        ydim = 2*abs(ftrk_par(i_det).lyr(i_lyr).coord0_y)
        alpha_cr = atan(xdim/ydim)
        if (abs(buffer(14)) .ge. 0. .and. 
     &      abs(buffer(14)) .le. alpha_cr) then
         cell_size = (ydim / ftrk_par(i_det).lyr(i_lyr).cos_stereo)
     &             /  ftrk_par(i_det).lyr(i_lyr).ncell
        else if (abs(buffer(14)) .gt. alpha_cr .and.
     &           abs(buffer(14)) .le. 1.5708) then
         cell_size = (xdim / ftrk_par(i_det).lyr(i_lyr).sin_stereo)
     &             /  ftrk_par(i_det).lyr(i_lyr).ncell
        end if
        ftrk_par(i_det).lyr(i_lyr).cell_size = cell_size
        ftrk_par(i_det).lyr(i_lyr).type     = int(buffer(18))
        if (buffer(19) .ne. 0.) then
         ftrk_par(i_det).lyr(i_lyr).eff_hit  = buffer(19)
        end if
        if (buffer(20) .ne. 0.) then
         ftrk_par(i_det).lyr(i_lyr).siga     = buffer(20)
        end if
        if (buffer(21) .ne. 0.) then
         ftrk_par(i_det).lyr(i_lyr).sigb     = buffer(21)
        end if
        if (buffer(22) .ne. 0.) then
         ftrk_par(i_det).lyr(i_lyr).sigc     = buffer(22)
        end if
c
        if (ftrk_par(i_det).zmin .ne. 0. .and.
     &      ftrk_par(i_det).zmax .ne. 0.) then
         if (ftrk_par(i_det).nlyr .gt. 0) then
          do i = 1,ftrk_par(i_det).nlyr
           thick_total = thick_total 
     &                 + ftrk_par(i_det).lyr(i).thickness
          end do
          z_length = ftrk_par(i_det).zmax 
     &             - ftrk_par(i_det).zmin
          if (thick_total .gt. z_length) then
           write(mcp_llpt, 6000) i_det, 
     &                           thick_total,
     &                           ftrk_par(i_det).nlyr,
     &                           z_length
           stop
          end if
         end if
        end if
c
        ftrk_par(i_det).nchan = nchan
c
       end if
c
      end if
c
c
c
      return
c
 5000 format('FORW. TRK. ', i4, ' : NO MATERIAL')
 5001 format('FORW. TRK. ', i4, ' : NO MATERIAL AT BOUN. ', i4)
 6000 format('FORW. TRK. ', i4, ' : overal length ', f10.4, 
     & ' required for ', i4, 
     & ' layers of thickness you have specified', /,
     & ' overal length ',f10.4,' you have specified is not big enough')
c
      end


c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:35  garren
c add rcs log line
c
