      subroutine close_det_geom(name)
************************************************************************
*
*       close_det_geom
*
*       MCFAST Geomview graphics
*
*       Closeout material for a detector geometry
*
************************************************************************
      implicit none
      character*(*) name
      integer lenocc
      external lenocc
#include "det_draw.inc"
*
      write(lungraph,'(10a)') ' { : ',name(:lenocc(name)),' } }'
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:54  garren
c add rcs log line
c
