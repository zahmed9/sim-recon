c
      subroutine geo_fill_dip(keyword,nstart,i_fill,buffer,char_name)
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
#include "mcp_luns.inc"
#include "dipole.inc"
#include "material.inc"
c
      integer num_dip
      integer i
      integer boundry
c
      num_dip = dip_num
c
      if (nstart .eq. 1) then
       num_dip = num_dip + 1
      end if
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        dip_par(num_dip).name = char_name
       end if
       if (nstart .eq. 12) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          dip_par(num_dip).mat_fill = i
          goto 100
         end if
        end do
  100   if (dip_par(num_dip).mat_fill .le. 0 .or.
     &      dip_par(num_dip).mat_fill .gt. mtl_num) then
         write (mcp_llpt,5000) num_dip
        end if
       end if
       if (nstart .gt. 18) then
        boundry = nstart - 18
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          dip_par(num_dip).mat_boun(boundry) = i
          goto 200
         end if
        end do
  200   if (dip_par(num_dip).mat_boun(boundry).le.0.or.
     &      dip_par(num_dip).mat_boun(boundry).gt.mtl_num) then
         write(mcp_llpt,5001) num_dip, boundry
        end if
       end if
      end if
c
      if (i_fill .gt. 0) then
       dip_par(num_dip).Bfield = buffer(3)
       do i = 1,3
        dip_par(num_dip).dircos(i) = buffer(3+i)
       end do
       dip_par(num_dip).xmin = buffer( 7)
       dip_par(num_dip).xmax = buffer( 8)
       dip_par(num_dip).ymin = buffer( 9)
       dip_par(num_dip).ymax = buffer(10)
       dip_par(num_dip).zmin = buffer(11) - buffer(12) / 2.
       dip_par(num_dip).zmax = buffer(11) + buffer(12) / 2.
       dip_par(num_dip).ptkick = 0.3*buffer(3)*buffer(12)
       do i = 1,6
        dip_par(num_dip).thick_boun(i) = buffer(13+i)
       end do
      end if
c
      dip_num = num_dip
c
      return
c
 5000 format('DIPOLE ',i4,' : UNKNOWN MATERIAL')
 5001 format('DIPOLE ',i4,' : UNKNOWN MATERIAL AT BOUNDRY ',i4)
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:34  garren
c add rcs log line
c
