c
      subroutine geo_fill_rich
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
#include "rich.inc"
#include "material.inc"
c
      integer num_rich
      integer i
      real rmin(2), rmax(2), zmin, zmax
      real eta_min, eta_max, theta_min, theta_max
      real thick_rad
c
      num_rich = certh_num
c
      if (nstart .eq. 1) then
       num_rich = num_rich + 1
      end if
c
      if (num_rich .gt. max_certh) num_rich = max_certh
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        certh_par(num_rich).name = char_name
       end if
       if (nstart .eq. 2) then
        certh_par(num_rich).shape = char_name
       end if
       if (nstart .eq. 9) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          certh_par(num_rich).material = i
          goto 100
         end if
        end do
  100   if (certh_par(num_rich).material .le. 0 .or.
     &      certh_par(num_rich).material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_rich
        end if
       end if
       if (nstart .eq. 11) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          certh_par(num_rich).mat_rad = i
          goto 200
         end if
        end do
  200   if (certh_par(num_rich).mat_rad .le. 0 .or.
     &      certh_par(num_rich).mat_rad .gt. mtl_num) then
         write(mcp_llpt, 5001) num_rich
        end if
       end if
      end if
c
      if (i_fill .gt. 0) then
c
       rmin(1) = buffer( 4)
       rmin(2) = buffer( 5)
       rmax(1) = buffer( 6)
       rmax(2) = buffer( 7)
       zmin    = buffer( 8) - buffer( 9) / 2.
       zmax    = buffer( 8) + buffer( 9) / 2.
       thick_rad = buffer(11)

        if (zmin .ge. zmax .or. 
     *      rmin(1) .ge. rmax(1) .or.
     *      rmin(2) .ge. rmax(2)) then
          write(mcp_llpt,5551) num_rich,zmin,zmax,
     *                         (rmin(i),i=1,2),(rmax(i),i=1,2)
          goto 300
        endif
c
       certh_par(num_rich).rmin(1) = rmin(1)
       certh_par(num_rich).rmin(2) = rmin(2)
       certh_par(num_rich).rmax(1) = rmax(1)
       certh_par(num_rich).rmax(2) = rmax(2)
       certh_par(num_rich).zmin    = zmin
       certh_par(num_rich).zmax    = zmax
       certh_par(num_rich).thick_rad = thick_rad
c
c     Calculate eta_min & eta_max
c
       if (zmin .lt. 0. .and. zmax .lt. 0.) then 
c      Backward
        if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_min = -9999.
        else
         if (rmin(1) .ge. rmin(2) .and. rmax(1) .ge. rmax(2)) then
            theta_max = abs( atan( rmin(2)/zmax) )
            eta_min  = alog( tan( theta_max/2. ) )
            theta_min = abs( atan( rmax(1)/zmin) )
            eta_max  = alog( tan( theta_min/2. ) )
         else
            theta_max = abs( atan( rmax(1)/zmin) )
            eta_min =  alog( tan( theta_max/2. ) )
            theta_min = abs( atan( rmin(2)/zmax) )
            eta_max =  alog( tan( theta_min/2. ) )
         end if
        end if
       elseif (zmin .gt. 0. .and. zmax .gt. 0.) then
c      Forward
        if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_max = 9999.
        else
         if (rmin(1) .le. rmin(2) .and. rmax(1) .le. rmax(2)) then
            theta_max = abs( atan( rmax(2)/zmax) )
            eta_min = -alog( tan( theta_max/2. ) ) 
            theta_min = abs( atan( rmin(1)/zmin) )
            eta_max = -alog( tan( theta_min/2. ) )
         else
            theta_max = abs( atan( rmin(1)/zmin ) )
            eta_min = - alog( tan( theta_max/2. ) )
            theta_min = abs( atan( rmax(2)/zmax ) )
            eta_max = - alog( tan( theta_min/2. ) )
         end if
        end if
       else
            eta_min = 0.                      ! not forward/backward geometry
            eta_max = 0.
       endif
c
       certh_par(num_rich).eta_min = eta_min
       certh_par(num_rich).eta_max = eta_max
c
       write(mcp_llpt,6000) num_rich,zmin,zmax,eta_min,eta_max
c
      end if
c
      certh_num = num_rich
c
  300 return
c
 5000 format(' RICH SYSTEM: ', i4, ' : UNKNOWN MATERIAL ')
 5001 format(' RICH SYSTEM: ', i4, ' : UNKNOWN MATERIAL FOR RADIATOR')
 5551 format(' RICH SYSTEM: ', i4, ' GEOMETRY ERROR:', /,
     &   'certh_num,zmin,zmax,rmin(1),rmin(2),rmax(1),rmax(2) ',
     &   i3,6f10.4 )
 6000 format(' RICH GEOM: certh_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:38  garren
c add rcs log line
c
