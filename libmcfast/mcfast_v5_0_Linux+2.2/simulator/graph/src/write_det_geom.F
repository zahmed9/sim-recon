      subroutine write_det_geom(itype,name)
************************************************************************
*
*       write_det_geom
*
*       MCFAST Geomview graphics
*
*       Write graphics header material for a detector geometry
*
************************************************************************
      implicit none
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      character*(*) name
      integer lun, lenocc, itype
      external lenocc
      character chedge*20
      record /color_s/ col
*
*-----------------------------------------------------------------------
*
      lun = lungraph
      write(lun,'(a)') '{'
***     appearance
      chedge = '+edge'
      write(lun,'(a)') 'appearance {'
      write(lun,'(a)') chedge
***     material
      write(lun,'(a)') 'material {'
      write(lun,'(a)') 'ka 0.5'
      call colorlevel(att(itype).color,col,.3)
      write(lun,'(a,3f9.3)') 'edgecolor ',col.r,col.g,col.b
      write(lun,'(a)') '}'
***     lighting
      write(lun,'(a)') 'lighting {'
      write(lun,'(a)') '}'
*
      write(lun,'(a)') '} # end appearance'
*
      write(lun,'(a)') 'LIST'
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:59  garren
c add rcs log line
c
