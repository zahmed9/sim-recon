      subroutine vtx_gen(num)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Generate primary vertices
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "beam_vertex.inc"
#include "prim_vertex.inc"

c     Calling argument
      integer num

c     Externals
      real get_gauss
      external get_gauss

c     Local variables
      integer i, ivtx
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Generate the primary vertex position
      prim_numvtx = num
      do ivtx=1,num
        do i=1,3
          prim_vertex(i,ivtx) = beam_vertex.pos(i)
     *                        + beam_vertex.sigma(i)*get_gauss(0)
        enddo
        prim_vertex(4,ivtx) = beam_vertex.sigma(3)*get_gauss(0)
      enddo


      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:20  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 18:08:01  garren
c add hooks to initialize user trigger code
c
