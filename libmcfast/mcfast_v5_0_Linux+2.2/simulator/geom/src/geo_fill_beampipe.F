c
      subroutine geo_fill_beampipe(keywd,nstart,ifill,buf,char_name)
c
      implicit none
c
      character*(*) keywd
c
      integer nstart, ifill
c
      real buf(*)
c
      character*(*) char_name
c
      integer i, boundry, num_bpipe
c
#include "mcp_luns.inc"
#include "beampipe.inc"
#include "material.inc"
c
      if (keywd .eq. 'BEAMPIPE') then
c
       if (ifill .eq. 0) then
        num_bpipe = beampipe_num
	
	if (nstart .eq. 1) then
	  num_bpipe = num_bpipe + 1
	endif
c
        if (char_name .ne. ' ') then
c
         if (nstart .eq. 1) then        
          beampipe_par(num_bpipe).name = char_name
         end if
	 
         if (nstart .eq. 6) then
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            beampipe_par(num_bpipe).material = i
            goto 100
           end if
          end do
  100     if (beampipe_par(num_bpipe).material .le. 0 .or. 
     &        beampipe_par(num_bpipe).material .gt. mtl_num) then
           write(mcp_llpt,5000)
          end if
         end if
         if (nstart .gt. 10) then
          boundry = nstart - 10
          do i = 1,mtl_num
           if (mtl_par(i).name .eq. char_name) then
            beampipe_par(num_bpipe).mat_boun(boundry) = i
            goto 200
           end if
          end do
  200     if (beampipe_par(num_bpipe).mat_boun(boundry) .le. 0 .or. 
     &      beampipe_par(num_bpipe).mat_boun(boundry) .gt. mtl_num) then
           write(mcp_llpt,6000) boundry
          end if
         end if
c
        end if
c
       else
c
        beampipe_par(num_bpipe).rmin = buf(3)
        beampipe_par(num_bpipe).rmax = buf(4)
        beampipe_par(num_bpipe).zmin = buf(5) - buf(6) / 2.
        beampipe_par(num_bpipe).zmax = buf(5) + buf(6) / 2.
        do i = 1,4
         beampipe_par(num_bpipe).thick_boun(i) = buf(7+i)
        end do
c
       end if
c
      end if
c
      return
c
 5000 format (' BEAMPIPE : UNKNOWN MATERIAL ')
 6000 format (' BEAMPIPE : UNKNOWN MATERIAL AT BOUN. ', i4)
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.3  1999/04/24 22:39:20  mcbride
c update to allow multiple beampipes
c
c Revision 1.2  1997/04/04  20:29:33  garren
c add rcs log line
c
