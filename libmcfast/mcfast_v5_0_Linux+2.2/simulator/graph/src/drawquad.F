      subroutine drawquad(itype,quad)
************************************************************************
*
*       drawquad
*
*       MCFAST Geomview graphics
*
*       Draw a quadrilateral
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      record /quad_s/ quad
      integer i, lun, itype
*
      lun = lungraph
      write(lun,'(a)') 'CQUAD'
      do i=1,4
        write(lun,'(3f9.3)') quad.p(i).x, quad.p(i).y, quad.p(i).z,
     +    att(itype).color.r,att(itype).color.g,att(itype).color.b,
     +    att(itype).trans
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:58  garren
c add rcs log line
c
