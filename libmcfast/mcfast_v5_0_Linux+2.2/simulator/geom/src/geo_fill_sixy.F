      subroutine geo_fill_sixy(keyword,i_fill,buffer,char_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
#include "sixy_disk.inc"
c
      character*(*) keyword
c
      integer nstart, i_fill
c
      real buffer(*)
c
      character*(*) char_name
c
      integer num_sixy
      integer i, i_count
      integer i_det, i_lyr
      integer id_mat
      integer nchan, nsegm
      real x_width, y_width
c
c
c
      i_det   = 0
      i_lyr   = 0
      i_count = 0
      id_mat  = 0
      nchan   = 0
      nsegm   = 0
c
c
c
      if (keyword .eq. 'SIXY') then
c
       num_sixy = int(buffer(2))
c
       if (num_sixy .gt. max_sixy) num_sixy = max_sixy
c
       if (i_fill .eq. 0) then
        if (char_name .ne. ' ') then
         sixy_num = sixy_num + 1
         sixy_par(num_sixy).name = char_name
        end if
       else
        sixy_par(num_sixy).numlyr = int(buffer(4))
        if (sixy_par(num_sixy).numlyr .gt. max_sixy_lyr) then
         sixy_par(num_sixy).numlyr = max_sixy_lyr
        end if
        if (sixy_par(num_sixy).z .ne. buffer(5)) then
         if (sixy_par(num_sixy).numlyr .gt. 0) then
          do i = 1,sixy_par(num_sixy).numlyr
           sixy_par(num_sixy).lyr(i).z =
     &     sixy_par(num_sixy).lyr(i).z + buffer(5)
          end do
         end if
        end if
        sixy_par(num_sixy).z      = buffer(5)
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERSIXY') then
c
       i_det = int(buffer(2))
       if (i_det .gt. max_sixy) i_det = max_sixy
       i_lyr = int(buffer(3))
       if (i_lyr .gt. max_sixy_lyr) i_lyr = max_sixy_lyr
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
        end if
        if (i_det .gt. 0 .and. i_lyr .gt. 0) then
         sixy_par(i_det).lyr(i_lyr).material = id_mat
        end if
       end if
c
       if (i_fill .eq. 1) then
c
        x_width = (buffer(11) - buffer(10))
     &          - (buffer(13) - buffer(12))
        y_width = (buffer(19) - buffer(18))
     &          - (buffer(21) - buffer(20))

        if (x_width .gt. 0. .and. y_width .gt. 0.) then
         nsegm = int( x_width / buffer(15) )
         if (nsegm .lt. int(buffer(14))) then
          write(mcp_llpt,6000) i_det, i_lyr, nsegm
          buffer(14) = float(nsegm)
         end if
         nsegm = int( y_width / buffer(23) )
         if (nsegm .lt. int(buffer(22))) then
          write(mcp_llpt,6001) i_det, i_lyr, nsegm
          buffer(22) = float(nsegm)
         end if
        end if
c
        sixy_par(i_det).lyr(i_lyr).xmin     = buffer(10)
        sixy_par(i_det).lyr(i_lyr).xmax     = buffer(11)
        sixy_par(i_det).lyr(i_lyr).xmin_gap = buffer(12)
        sixy_par(i_det).lyr(i_lyr).xmax_gap = buffer(13)
        sixy_par(i_det).lyr(i_lyr).nsegm_x  = int(buffer(14))
        sixy_par(i_det).lyr(i_lyr).pitch_x  = buffer(15)
        sixy_par(i_det).lyr(i_lyr).coord0_x = buffer(16)
        sixy_par(i_det).lyr(i_lyr).siga_x   = buffer(17)
        sixy_par(i_det).lyr(i_lyr).ymin     = buffer(18)
        sixy_par(i_det).lyr(i_lyr).ymax     = buffer(19)
        sixy_par(i_det).lyr(i_lyr).ymin_gap = buffer(20)
        sixy_par(i_det).lyr(i_lyr).ymax_gap = buffer(21)
        sixy_par(i_det).lyr(i_lyr).nsegm_y  = int(buffer(22))
        sixy_par(i_det).lyr(i_lyr).pitch_y  = buffer(23)
        sixy_par(i_det).lyr(i_lyr).coord0_y = buffer(24)
        sixy_par(i_det).lyr(i_lyr).siga_y   = buffer(25)
c
        sixy_par(i_det).lyr(i_lyr).z        = 
     &                    sixy_par(i_det).z + buffer( 5)
        sixy_par(i_det).lyr(i_lyr).thick    = buffer( 6)
        sixy_par(i_det).lyr(i_lyr).stereo   = buffer( 7)
        nchan = sixy_par(i_det).nchan 
     &        - sixy_par(i_det).lyr(i_lyr).nchan
        sixy_par(i_det).lyr(i_lyr).nchan    = 
     &       sixy_par(i_det).lyr(i_lyr).nsegm_x *
     &       sixy_par(i_det).lyr(i_lyr).nsegm_y
        nchan = nchan + sixy_par(i_det).lyr(i_lyr).nchan
        sixy_par(i_det).lyr(i_lyr).type     = int(buffer( 8))
        sixy_par(i_det).lyr(i_lyr).eff_hit  = buffer( 9)
c
        sixy_par(i_det).nchan = nchan
c
       end if
c
      end if
c
c
c
      return
c
 5000 format(' SIXY ', i4, ' ERROR : NO MATERIAL FOR LAYER ', i4)
 6000 format(' SIXY ', i4, ' LAYER ', i4, ' :', /,
     &       ' max number of strips along x-axis can not exceed ',i8)
 6001 format(' SIXY ', i4, ' LAYER ', i4, ' :', /,
     &       ' max number of strips along y-axis can not exceed ',i8)

c
      end


c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:41  garren
c add rcs log line
c
