c
      subroutine geo_fill_sol(keyword,nstart,i_fill,buffer,char_name)
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
#include "solenoid.inc"
#include "material.inc"
c
      integer num_sol
      integer i
      integer boundry
c
      num_sol = sol_num
c
      if (nstart .eq. 1) then
       num_sol = num_sol + 1
      end if
c
      if (char_name .ne. ' ') then
       if (nstart .eq. 1) then
        sol_par(num_sol).name = char_name
       end if
       if (nstart .eq. 7) then
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          sol_par(num_sol).mat_fill = i
          goto 100
         end if
        end do
  100   if (sol_par(num_sol).mat_fill .le. 0 .or.
     &      sol_par(num_sol).mat_fill .gt. mtl_num) then
         write (mcp_llpt,5000) num_sol
        end if
       end if
       if (nstart .gt. 11) then
        boundry = nstart - 11
        do i = 1,mtl_num
         if (mtl_par(i).name .eq. char_name) then
          sol_par(num_sol).mat_boun(boundry) = i
          goto 200
         end if
        end do
  200   if (sol_par(num_sol).mat_boun(boundry).le.0.or.
     &      sol_par(num_sol).mat_boun(boundry).gt.mtl_num) then
         write(mcp_llpt,5001) num_sol, boundry
        end if
       end if
      end if
c
      if (i_fill .gt. 0) then
       sol_par(num_sol).Bfield = buffer(3)
       sol_par(num_sol).rmin = buffer( 4)
       sol_par(num_sol).rmax = buffer( 5)
       sol_par(num_sol).zmin = buffer( 6) - buffer( 7) / 2.
       sol_par(num_sol).zmax = buffer( 6) + buffer( 7) / 2.
       do i = 1,4
        sol_par(num_sol).thick_boun(i) = buffer(8+i)
       end do
      end if
c
      sol_num = num_sol
c
      return
c
 5000 format('SOLENOID ',i4,' : UNKNOWN MATERIAL')
 5001 format('SOLENOID ',i4,' : UNKNOWN MATERIAL AT BOUNDRY ',i4)
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
