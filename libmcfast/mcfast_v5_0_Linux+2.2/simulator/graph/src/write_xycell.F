      subroutine write_xycell(itype,xmin,xmax,ymin,ymax,z)
************************************************************************
*
*       write_xycell
*
*       MCFAST Geomview graphics
*
*       Write graphics commands for Si XY cells
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      DFLOAT xmin,xmax,ymin,ymax,z
      integer k, lun, itype
      record /quad_s/ quad
*
      lun = lungraph
      quad.p(1).x = xmin
      quad.p(1).y = ymax
      quad.p(1).z = z
      quad.p(2).x = xmin
      quad.p(2).y = ymin
      quad.p(2).z = z
      quad.p(3).x = xmax
      quad.p(3).y = ymin
      quad.p(3).z = z
      quad.p(4).x = xmax
      quad.p(4).y = ymax
      quad.p(4).z = z
      call drawquad(itype,quad)
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:00  garren
c add rcs log line
c
