      subroutine load_beam_vrtx
      implicit none
      integer i
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "beam_vertex.inc"
*
      do i=1,3
        beam_vertex.pos(i) = beamvrtx(1).xyz(i)
        beam_vertex.sigma(i) = beamvrtx(1).sig(i)
      enddo
*
      write(mcp_llpt,'(a,6f8.3)') ' Beam vertex X,sig:',
     +  (beam_vertex.pos(i),i=1,3),(beam_vertex.sigma(i),i=1,3)
*
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:48  garren
c add rcs log line
c
