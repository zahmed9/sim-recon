      subroutine colorlevel(color,newcolor,f1)
************************************************************************
*
*       colorlevel
*
*       MCFAST Geomview graphics
*
*       Set color level
*
************************************************************************
#include "det_structure.inc"
#include "det_att_structure.inc"
      record /color_s/ color, newcolor
      real f,f1
*
      f = min(f1,2.)
      if (f.lt.1.) then
        newcolor.r = color.r*f
        newcolor.g = color.g*f
        newcolor.b = color.b*f
      else
        newcolor.r = color.r + (1.-color.r)*(f-1.)
        newcolor.g = color.g + (1.-color.g)*(f-1.)
        newcolor.b = color.b + (1.-color.b)*(f-1.)
      endif
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.3  1998/04/27 01:35:08  kutschke
c Do not overwrite f argument.
c
c Revision 1.2  1997/04/04  20:29:55  garren
c add rcs log line
c
