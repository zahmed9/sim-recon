c
      subroutine geo_fill_beam_vrtx(keyword, i_fill, buffer)
c
      implicit none
c
#include "beam_vertex.inc"
c
      character*(*) keyword
c
      integer i_fill
c
      real buffer(*)
c
      integer i
c
      if (keyword .eq. 'BEAMVRTX') then
       do i = 1,3
        beam_vertex.pos(i)   = buffer(i+1)
        beam_vertex.sigma(i) = buffer(i+4)
       end do
      end if
c
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:33  garren
c add rcs log line
c
