      subroutine quad_phirot(quad,phi)
************************************************************************
*
*       quad_phirot
*
*       MCFAST Geomview graphics
*
*       rotate quad object by phi; ie. coords in -phi rotated frame
*
************************************************************************
      implicit none
#include "det_draw.inc"
      record /quad_s/ quad, qnew
      integer i
      DFLOAT phi
*
      do i=1,4
        qnew.p(i).x = quad.p(i).x*cos(phi) - quad.p(i).y*sin(phi)
        qnew.p(i).y = quad.p(i).x*sin(phi) + quad.p(i).y*cos(phi)
        qnew.p(i).z = quad.p(i).z
      enddo
      quad = qnew
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:59  garren
c add rcs log line
c
