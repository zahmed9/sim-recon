c
      subroutine geo_fill_hcal
     &           (keyword,nstart,i_fill,buffer,char_name)
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
#include "hadcal.inc"
#include "material.inc"
c
      integer num_hcal
      integer i
      real rmin(2), rmax(2), zmin, zmax
      integer type
      real eta_min, eta_max, theta_min, theta_max
      integer nphi, neta
      real siga, sigb
c
      num_hcal = hcal_num
c
      if (nstart .eq. 1) then
       num_hcal = num_hcal + 1
      end if
c
      if (num_hcal .gt. max_hcal) num_hcal = max_hcal
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        hcal_par(num_hcal).name = char_name
       end if
       if (nstart .eq. 2) then
        hcal_par(num_hcal).shape = char_name
       end if
       if (nstart .eq. 10) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          hcal_par(num_hcal).material = i
          goto 100
         end if
        end do
  100   if (hcal_par(num_hcal).material .le. 0 .or.
     &      hcal_par(num_hcal).material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_hcal
        end if
       end if       
       if (nstart .eq. 11) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          hcal_par(num_hcal).active_material = i
          goto 101
         end if
        end do
  101   if (hcal_par(num_hcal).active_material .le. 0 .or.
     &      hcal_par(num_hcal).active_material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_hcal
        end if
       end if
      end if
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
       nphi    = int(buffer(13))
       neta    = int(buffer(14))
       siga    = buffer(15)
       sigb    = buffer(16)

       if (type .eq. 1) then
        if (zmin .ge. zmax .or. 
     *      rmin(1) .ge. rmax(1) .or.
     *      rmin(2) .ge. rmax(2)) then
          write(mcp_llpt,5551) num_hcal
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

       hcal_par(num_hcal).type    = type
       hcal_par(num_hcal).rmin(1) = rmin(1)
       hcal_par(num_hcal).rmin(2) = rmin(2)
       hcal_par(num_hcal).rmax(1) = rmax(1)
       hcal_par(num_hcal).rmax(2) = rmax(2)
       hcal_par(num_hcal).zmin    = zmin
       hcal_par(num_hcal).zmax    = zmax
       hcal_par(num_hcal).nphi    = nphi
       hcal_par(num_hcal).neta    = neta
       hcal_par(num_hcal).siga    = siga
       hcal_par(num_hcal).sigb    = sigb
c
c     Calculate eta_min & eta_max
c
       call geteta(type,rmin,rmax,zmin,zmax,eta_min,eta_max)
c
       hcal_par(num_hcal).eta_min = eta_min
       hcal_par(num_hcal).eta_max = eta_max
c
       write(mcp_llpt,6000) num_hcal,zmin,zmax,eta_min,eta_max
c
      end if
c
      hcal_num = num_hcal
c
  200 return
c
 5000 format(' HAD Cal.: ', i4, ' : UNKNOWN MATERIAL ')
 5551 format(' HAD Cal.: ', i4, ' BARREL GEOMETRY ERROR' )
 5552 format(' HAD Cal.: Forward geometry error, 
     *         zmin,zmax: ', 2f10.3)
 6000 format(' HAD Cal. GEOM: hcal_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:29:36  garren
c add rcs log line
c
