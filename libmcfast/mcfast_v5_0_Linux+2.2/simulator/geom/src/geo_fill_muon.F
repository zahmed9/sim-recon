c
      subroutine geo_fill_muon
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
#include "muon.inc"
#include "material.inc"
c
      integer num_muon
      integer i
      real rmin(2), rmax(2), zmin, zmax
      integer type
      real eta_min, eta_max, theta_min, theta_max
      integer nlyr
c
      num_muon = muon_num
c
      if (nstart .eq. 1) then
       num_muon = num_muon + 1
      end if
c
      if (num_muon .gt. max_muon) num_muon = max_muon
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        muon_par(num_muon).name = char_name
       end if
       if (nstart .eq. 2) then
        muon_par(num_muon).shape = char_name
       end if
       if (nstart .eq. 10) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          muon_par(num_muon).material = i
          goto 100
         end if
        end do
  100   if (muon_par(num_muon).material .le. 0 .or.
     &      muon_par(num_muon).material .gt. mtl_num) then
         write(mcp_llpt, 5000) num_muon
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
       nlyr    = int(buffer(12))

       if (type .eq. 1) then
        if (zmin .ge. zmax .or. 
     *      rmin(1) .ge. rmax(1) .or.
     *      rmin(2) .ge. rmax(2)) then
          write(mcp_llpt,5551) num_muon
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

       muon_par(num_muon).type    = type
       muon_par(num_muon).rmin(1) = rmin(1)
       muon_par(num_muon).rmin(2) = rmin(2)
       muon_par(num_muon).rmax(1) = rmax(1)
       muon_par(num_muon).rmax(2) = rmax(2)
       muon_par(num_muon).zmin    = zmin
       muon_par(num_muon).zmax    = zmax
       muon_par(num_muon).nlyr    = nlyr
c
c     Calculate eta_min & eta_max
c
       if (type .eq. 1) then
c
       if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_min = 9999.
         eta_max = 9999.
       else
         if (zmin .ne. 0.) then
           theta_max =  abs( atan( rmin(1)/zmin ) )
           eta_min   =  - alog( tan( theta_max/2. ) ) 
           if (zmin .lt. 0.) eta_min = - eta_min
         else
           eta_min = 0.
         endif
         if (zmax .ne. 0.) then
           theta_min =    abs( atan( rmin(2)/zmax ) )
           eta_max   = - alog(  tan( theta_min/2. ) )
           if (zmax .lt. 0.) eta_max = - eta_max
         else
           eta_max = 0.
         endif
       end if
c       
       end if
c
       if (type .eq. 2) then
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
       end if
c
       muon_par(num_muon).eta_min = eta_min
       muon_par(num_muon).eta_max = eta_max
c
       write(mcp_llpt,6000) num_muon,zmin,zmax,eta_min,eta_max
c
      end if
c
      muon_num = num_muon
c
  200 return
c
 5000 format(' MUON SYSTEM: ', i4, ' : UNKNOWN MATERIAL ')
 5551 format(' MUON SYSTEM: ', i4, ' BARREL GEOMETRY ERROR' )
 5552 format(' MUON SYSTEM: Forward geometry error, 
     *         zmin,zmax: ', 2f10.3)
 6000 format(' MUON GEOM: muon_num,zmin,zmax,eta_min,eta_max', 
     +         i3,4f10.4) 
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:37  garren
c add rcs log line
c
