      subroutine open_graphics
************************************************************************
*
*       open_graphics
*
*       MCFAST Geomview graphics
*
*       Set up detector graphics
*
************************************************************************
      implicit none
#include "det_draw.inc"
*
*-----------------------------------------------------------------------
*
      write(lungraph,'(a)') '(geometry Detector { : Detector_g })'
      write(lungraph,'(a)') '(bbox-draw Detector no)'
      write(lungraph,'(a)') '(read geometry { define Detector_g'
      write(lungraph,'(a)') 'LIST'
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:58  garren
c add rcs log line
c
