      subroutine geteta(itype,rmin,rmax,zmin,zmax,eta_min,eta_max)

      implicit none
      real rmin(2), rmax(2), zmin, zmax, eta_min, eta_max
      real theta_max, theta_min
      integer itype, itype_temp

c
c     Calculate eta_min & eta_max
c

c     Temporary fix since now we allow type=51 for seg.type="z-phi"
c                                  and type=52 for seg.type="r-phi"
      itype_temp = mod( itype, 10 )

c
c     Central EMCAL
c
       if (itype_temp .eq. 1) then
       if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_min = 9999.
         eta_max = 9999.
       else
         if (zmin .lt. 0.) then
           theta_max =  abs( atan( rmin(1)/zmin ) )
           eta_min   =  - alog( tan( theta_max/2. ) ) 
           eta_min = - eta_min
         elseif (zmin .gt. 0.) then
           theta_max =  abs( atan( rmax(1)/zmin ) )
           eta_min   =  - alog( tan( theta_max/2. ) )          
         else
           eta_min = 0.
         endif
         if (zmax .lt. 0.) then
           theta_min =    abs( atan( rmax(2)/zmax ) )
           eta_max   = - alog(  tan( theta_min/2. ) )
           eta_max = - eta_max
         else if (zmax .gt. 0) then
           theta_min =    abs( atan( rmin(2)/zmax ) )
           eta_max   = - alog(  tan( theta_min/2. ) )
         else
           eta_max = 0.
         endif
       end if
       end if

c
c     Backward/Forward EMCAL
c
       if (itype_temp .eq. 2) then
       if (zmin .lt. 0. .and. zmax .lt. 0.) then 
c      Backward
        if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_min = -9999.
        else
         theta_max =  abs( atan( rmin(2)/zmax) )
         eta_min   =  alog( tan( theta_max/2. ) )
         theta_min =  abs( atan( rmax(2)/zmax) )
         eta_max   =  alog( tan( theta_min/2. ) )
        end if
       elseif (zmin .gt. 0. .and. zmax .gt. 0.) then
c      Forward
        if (rmin(1) .le. 0. .or. rmin(2) .le. 0.) then
         eta_max = 9999.
        else
         theta_max =  abs( atan( rmax(1)/zmin) )
         eta_min   = -alog( tan( theta_max/2. ) ) 
         theta_min =  abs( atan( rmin(1)/zmin) )
         eta_max   = -alog( tan( theta_min/2. ) )
        end if
       else
            eta_min = 0.                      ! not forward/backward geometry
            eta_max = 0.
       endif
       end if

       return
       end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.7  1999/05/13 18:14:35  yarba_j
c bug fix - manipulate cal type in a safe way !
c
c Revision 1.6  1999/02/25  18:48:38  yarba_j
c minor cleanup
c
c Revision 1.5  1999/02/22  23:20:55  yarba_j
c handle type=51/52 properly
c
c Revision 1.4  1997/04/04  20:29:46  garren
c add rcs log line
c

