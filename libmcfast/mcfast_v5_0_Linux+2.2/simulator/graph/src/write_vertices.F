      subroutine write_vertices(itype,str)
************************************************************************
*
*       write_vertices
*
*       MCFAST Geomview graphics
*
*       Write graphics commands for vertices
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      character*(*) str
      integer lun, itype
*
      lun = lungraph
      write(lun,1000) str,
     +  att(itype).color.r,att(itype).color.g,att(itype).color.b,
     +  att(itype).trans
 1000 format(a,4f6.3)
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:00  garren
c add rcs log line
c
