      subroutine geo_fill_sidisk(keyword,i_fill,buffer,char_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
#include "sicir_disk.inc"
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
      integer num_sicir
      integer i
      integer i_det, i_lyr, i_wed
      integer id_mat
      integer nchan, nstrip
c
      real dbeta, beta, dphi
      real stereo, cos_stereo, sin_stereo
      real ratio, rmx, rmn, width, pitch, d_phi
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
      nstrip  = 0
c
c
c
      if (keyword .eq. 'SIDISK') then
c
       num_sicir = int(buffer(2))
c
       if (num_sicir .gt. max_sicir) num_sicir = max_sicir
c
       if (i_fill .eq. 0) then
        if (char_name .ne. ' ') then
         sicir_num = sicir_num + 1
         sicir_par(num_sicir).name = char_name
        end if
       else
        sicir_par(num_sicir).numlyr = int(buffer(4))
        if (sicir_par(num_sicir).numlyr .gt. max_sicir_lyr) then
         sicir_par(num_sicir).numlyr = max_sicir_lyr
        end if
        if (sicir_par(num_sicir).z .ne. buffer(5)) then
         if (sicir_par(num_sicir).numlyr .gt. 0) then
          do i = 1,sicir_par(num_sicir).numlyr
           sicir_par(num_sicir).lyr(i).wedge(1).z =
     &     sicir_par(num_sicir).lyr(i).wedge(1).z + buffer(5)
           if (sicir_par(num_sicir).lyr(i).numwedge .gt. 
     &         max_sicir_wedge) then
            sicir_par(num_sicir).lyr(i).numwedge = max_sicir_wedge
           end if
           if (sicir_par(num_sicir).lyr(i).numwedge .gt. 0) then
            do i_wed = 1,sicir_par(num_sicir).lyr(i).numwedge
             sicir_par(num_sicir).lyr(i).wedge(i_wed).z =
     &             sicir_par(num_sicir).lyr(i).wedge(1).z 
            end do
           end if
          end do
         end if
        end if
        sicir_par(num_sicir).z = buffer(5)
       end if
c
      end if
c
c
c
      if (keyword .eq. 'LAYERSIDI') then
c
       i_det = int(buffer(2))
       if (i_det .gt. max_sicir) i_det = max_sicir
       i_lyr = int(buffer(3))
       if (i_lyr .gt. max_sicir_lyr) i_lyr = max_sicir_lyr
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
         sicir_par(i_det).lyr(i_lyr).wedge(1).material = id_mat
        end if
       end if
c
       if (i_fill .eq. 1) then
c
        sicir_par(i_det).lyr(i_lyr).numwedge = int(buffer(5))
        sicir_par(i_det).lyr(i_lyr).wedge(1).z  = 
     &                   sicir_par(i_det).z + buffer(6)
        sicir_par(i_det).lyr(i_lyr).wedge(1).thick = buffer( 7)
        sicir_par(i_det).lyr(i_lyr).wedge(1).rmin  = buffer( 8)
        sicir_par(i_det).lyr(i_lyr).wedge(1).rmax  = buffer( 9)
        sicir_par(i_det).lyr(i_lyr).phi(1)         = buffer(10)
        sicir_par(i_det).lyr(i_lyr).phi(2)         = buffer(11)
        dbeta = abs(buffer(11) - buffer(10)) 
     &        /     sicir_par(i_det).lyr(i_lyr).numwedge
        dphi = buffer(12)
        sicir_par(i_det).lyr(i_lyr).wedge(1).d_phi = dphi
        sicir_par(i_det).lyr(i_lyr).wedge(1).type = int(buffer(13))
c
        if (sicir_par(i_det).lyr(i_lyr).numwedge .gt. 0) then
         do i = 1,sicir_par(i_det).lyr(i_lyr).numwedge
          sicir_par(i_det).lyr(i_lyr).wedge(i).material =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).material
          sicir_par(i_det).lyr(i_lyr).wedge(i).z =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).z
          sicir_par(i_det).lyr(i_lyr).wedge(i).thick =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).thick
          sicir_par(i_det).lyr(i_lyr).wedge(i).rmin =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
          sicir_par(i_det).lyr(i_lyr).wedge(i).rmax =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
          sicir_par(i_det).lyr(i_lyr).wedge(i).d_phi =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).d_phi
          sicir_par(i_det).lyr(i_lyr).wedge(i).type =
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).type
          beta = sicir_par(i_det).lyr(i_lyr).phi(1)
     &         + dbeta / 2. + dbeta * (i - 1)
          sicir_par(i_det).lyr(i_lyr).wedge(i).beta = beta
          sicir_par(i_det).lyr(i_lyr).wedge(i).cos_beta = 
     &    cos(beta)
          sicir_par(i_det).lyr(i_lyr).wedge(i).sin_beta =
     &    sin(beta)
         end do
        end if
c
       end if
c
      end if
c
c
c
      if (keyword .eq. 'WEDGE') then
c
       if (char_name .ne. ' ') then
        speci = char_name
       end if
c
       if (i_fill .gt. 0) then
c
        i_det = int(buffer(3))
        if (i_det .gt. max_sicir) i_det = max_sicir
        i_lyr = int(buffer(4))
        if (i_lyr .gt. max_sicir_lyr) i_lyr = max_sicir_lyr
c
        if (speci .eq. 'ALL') then
c
         stereo = buffer(9)
         cos_stereo = cos(stereo)
         sin_stereo = sin(stereo)
c
         d_phi = 2 . * abs(buffer(7))

         if (d_phi .gt. 0. .and.
     &       buffer(6) .ge. 
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmin 
     &       .and.
     &       buffer(6) .le. 
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
     &       .and.
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmax .gt.
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmin) then

          ratio = 2. * buffer(6) 
     &    / ( sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
     &    +   sicir_par(i_det).lyr(i_lyr).wedge(1).rmax )
          if (ratio .le. 1.) then
           rmn = buffer(6)
           rmx = sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
     &         - buffer(6) 
     &         + sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
          else
           rmx = buffer(6)
           rmn = sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
     &         + sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
     &         - buffer(6)
          end if
          if (abs(stereo) .le. d_phi/2.) then
           width = 2. * rmx * tan(0.5 * d_phi)
           pitch = buffer(8) / cos_stereo
           nstrip = int( width / pitch )
          else if (abs(stereo) .gt. d_phi/2. .and.
     &             abs(stereo) .le. pi/4.) then
           width = (rmx - rmn) / cos(0.5*d_phi)
     &            + 2.* rmn * tan(0.5*d_phi) * cos_stereo
           nstrip = int( width / buffer(8) )
          end if
          if (nstrip .lt. int(buffer(5))) then
           write(mcp_llpt,6000) i_det, i_lyr, nstrip
           buffer(5) = float(nstrip)
          end if
         end if
c
         sicir_par(i_det).nchan = sicir_par(i_det).nchan
     &                          - sicir_par(i_det).lyr(i_lyr).nchan
         if (sicir_par(i_det).lyr(i_lyr).numwedge .gt. 0) then
          do i_wed = 1,sicir_par(i_det).lyr(i_lyr).numwedge
           nchan = nchan + int(buffer(5))
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nstrip = 
     &           int(buffer(5))
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nchan  = 
     &           int(buffer(5))
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).coord0_r = 
     &           buffer(6)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).coord0_phi = 
     &           buffer(7)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).chan0  = 0
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).pitch  = 
     &           buffer(8)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).stereo = stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).cos_stereo = 
     &           cos_stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sin_stereo = 
     &           sin_stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).eff_hit = 
     &           buffer(10)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).siga   = 
     &           buffer(11)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sigb   = 
     &           buffer(12)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sigc   = 
     &           buffer(13)
          end do
         end if
c
         sicir_par(i_det).lyr(i_lyr).nchan = nchan
         sicir_par(i_det).nchan = sicir_par(i_det).nchan 
     &       + sicir_par(i_det).lyr(i_lyr).nchan
c
        end if
c
        if (speci .eq. 'SPC') then
c
         i_wed = int(buffer(5))
         if (i_wed .gt. max_sicir_wedge) i_wed = max_sicir_wedge
c
         stereo = buffer(10)
         cos_stereo = cos(stereo)
         sin_stereo = sin(stereo)
c
         d_phi = 2. * abs(buffer(8))
c
         if (d_phi .gt. 0. .and.
     &       buffer(7) .ge. 
     &       sicir_par(i_det).lyr(i_lyr).wedge(i_wed).rmin
     &       .and.
     &       buffer(7) .le. 
     &       sicir_par(i_det).lyr(i_lyr).wedge(i_wed).rmax
     &       .and.
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmax .gt.
     &       sicir_par(i_det).lyr(i_lyr).wedge(1).rmin) then
          ratio = 2. * buffer(7)
     &    / (sicir_par(i_det).lyr(i_lyr).wedge(i_wed).rmin
     &    +  sicir_par(i_det).lyr(i_lyr).wedge(i_wed).rmax)
          if (ratio .le. 1.) then
           rmn = buffer(7)
           rmx = sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
     &         - buffer(7) 
     &         + sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
          else
           rmx = buffer(7)
           rmn = sicir_par(i_det).lyr(i_lyr).wedge(1).rmin
     &         + sicir_par(i_det).lyr(i_lyr).wedge(1).rmax
     &         - buffer(7)
          end if
          if (abs(stereo) .le. d_phi/2.) then
           width = 2. * rmx * tan(0.5 * d_phi)
           pitch = buffer(9) / cos_stereo
           nstrip = int( width / pitch )
          else if (abs(stereo) .gt. d_phi/2. .and.
     &             abs(stereo) .le. pi/4.) then
           width = (rmx - rmn) / cos(0.5*d_phi)
     &            + 2. * rmn * tan(0.5*d_phi) * cos_stereo
           nstrip = int( width / buffer(9) )
          end if
          if (nstrip .lt. int(buffer(6))) then
           write(mcp_llpt,6001) i_det, i_lyr, i_wed, nstrip
           buffer(6) = float(nstrip)
          end if
         end if
c
         sicir_par(i_det).nchan = sicir_par(i_det).nchan
     &   - sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nchan
         sicir_par(i_det).lyr(i_lyr).nchan = 
     &     sicir_par(i_det).lyr(i_lyr).nchan
     &   - sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nchan
c
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nstrip = 
     &           int(buffer(6))
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nchan  = 
     &           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).nchan  
     &         + int(buffer(6))
           sicir_par(i_det).nchan = sicir_par(i_det).nchan + 
     &           int(buffer(6))
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).coord0_r = 
     &           buffer(7)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).coord0_phi = 
     &           buffer(8)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).chan0  = 0
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).pitch  = 
     &           buffer(9)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).stereo = 
     &           stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).cos_stereo = 
     &                                              cos_stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sin_stereo = 
     &                                              sin_stereo
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).eff_hit = 
     &           buffer(11)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).siga   = 
     &           buffer(12)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sigb   = 
     &           buffer(13)
           sicir_par(i_det).lyr(i_lyr).wedge(i_wed).sigc   = 
     &           buffer(14)
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
 5000 format('SI DISK ', i4, ' ERROR : NO MATERIAL FOR LAYER ', i4)
 6000 format('SI DISK ', i4, ' LAYER ', i4, ' :', /,
     &       'max number of strips on wedge can not exceed ', i8)
 6001 format('SI DISK ', i4, ' LAYER ', i4, 'WEDGE ', i4, ' :', /,
     &       'max number of strips on wedge can not exceed ', i8)
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.6  1997/04/04 20:29:40  garren
c add rcs log line
c

