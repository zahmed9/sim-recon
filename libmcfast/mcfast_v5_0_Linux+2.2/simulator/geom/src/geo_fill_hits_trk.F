c
      subroutine geo_fill_hits_trk(keyword, i_fill, buffer)
c
      character*(*) keyword
c
      integer i_fill
c
      real buffer(*)
c
#include "track_minhit.inc"
c
      trk_minhit.all = 30
      trk_minhit.z   = 5
      trk_minhit.svx = 3
c
      if (keyword .eq. 'HITSONTRACK' .and. 
     &    i_fill .gt. 0) then
      trk_minhit.all = int(buffer(2))
      trk_minhit.z   = int(buffer(3))
      trk_minhit.svx = int(buffer(4))
      end if
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:36  garren
c add rcs log line
c
