      subroutine close_graphics
************************************************************************
*
*       close_graphics
*
*       MCFAST Geomview graphics
*
*       Graphics closeout
*
************************************************************************
      implicit none
#include "det_draw.inc"
*
      if (.not.geomview_out) return

      write(lungraph,'(a)') '})'
      close(lungraph)
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:55  garren
c add rcs log line
c
