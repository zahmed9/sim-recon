      subroutine drawhits
************************************************************************
*
*       drawhits
*
*       MCFAST Geomview graphics
*
*       Draw the hits. Most computationally lightweight option for
*       a 3D hit looks like an OFF will use a diamond.
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "hit_track.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      integer lun, i, j
      record /diam_s/ diam
      DFLOAT diamdim
      data diamdim /2./   ! diamond dimension in cm
      save diamdim
      record /color_s/ col
*
*-----------------------------------------------------------------------
*
      if (.not.geomview_out) return

      lun = lungraph
*
***     are there hits to draw?
*
      if (hit_trk_num.eq.0) then
        print *,'No hits to draw'
        return
      endif
*
      write(lun,*) 'LIST'
      do i=1, hit_trk_num
***       create a diamond, rotate according to hit plane, and install 
*         at hit pnt
*
*              1
*
*          2  4+,5- 0
*
*              3
*
        diam.p(1).x = diamdim
        diam.p(1).y = 0
        diam.p(1).z = 0
        diam.p(2).x = 0
        diam.p(2).y = diamdim
        diam.p(2).z = 0
        diam.p(3).x = -diamdim
        diam.p(3).y = 0
        diam.p(3).z = 0
        diam.p(4).x = 0
        diam.p(4).y = -diamdim
        diam.p(4).z = 0
        diam.p(5).x = 0
        diam.p(5).y = 0
        diam.p(5).z = diamdim/2.
        diam.p(6).x = 0
        diam.p(6).y = 0
        diam.p(6).z = -diamdim/2.
*
***       rotate and move the diamond to desired position
*
        do j=1,6
c $$$  rotate
***         translate
          diam.p(j).x = diam.p(j).x + hit_trk(i).pos(1)
          diam.p(j).y = diam.p(j).y + hit_trk(i).pos(2)
          diam.p(j).z = diam.p(j).z + hit_trk(i).pos(3)
        enddo
*
***       draw it; color is keyed by detector type
        write(lun,'(a)') 'appearance {'
        write(lun,'(a)') '+edge'
        write(lun,'(a)') 'linewidth 1'
        write(lun,'(a)') 'material {'
        write(lun,'(a)') 'ka .8'
        call colorlevel(att(hit_trk(i).chan.devtype).color,col,1.6)
        write(lun,'(a,3f9.3)') 'edgecolor ',col.r,col.g,col.b
        write(lun,'(a)') '}'
        write(lun,'(a)') '} # end appearance'
*
        write(lun,*) 'LIST'
        write(lun,*) 'OFF'
        write(lun,*) '6 8 0'
        write(lun,'(3f12.5)') (diam.p(j).x,diam.p(j).y,diam.p(j).z,
     +    j=1,6)
        call colorlevel(att(hit_trk(i).chan.devtype).color,col,1.3)
        write(lun,1000) '3 0 4 1',col.r,col.g,col.b,1.
        write(lun,1000) '3 1 4 2',col.r,col.g,col.b,1.
        write(lun,1000) '3 2 4 3',col.r,col.g,col.b,1.
        write(lun,1000) '3 3 4 0',col.r,col.g,col.b,1.
        write(lun,1000) '3 1 5 0',col.r,col.g,col.b,1.
        write(lun,1000) '3 2 5 1',col.r,col.g,col.b,1.
        write(lun,1000) '3 3 5 2',col.r,col.g,col.b,1.
        write(lun,1000) '3 0 5 3',col.r,col.g,col.b,1.
 1000   format(a,4f9.3)
***       supplement the OFF with VECTs to have reasonable rendition when sides and
*         edges are off
        write(lun,*) 'VECT'
        write(lun,*) '2 8 2'    ! nline nvert ncolor
        write(lun,*) '4 4'      ! no. of vertices in polyline
        write(lun,*) '1 1'      ! no. of colors in polyline 1
        write(lun,'(3f12.5)') diam.p(1).x,diam.p(1).y,diam.p(1).z
        write(lun,'(3f12.5)') diam.p(2).x,diam.p(2).y,diam.p(2).z
        write(lun,'(3f12.5)') diam.p(3).x,diam.p(3).y,diam.p(3).z
        write(lun,'(3f12.5)') diam.p(4).x,diam.p(4).y,diam.p(4).z
        write(lun,'(3f12.5)') diam.p(2).x,diam.p(2).y,diam.p(2).z
        write(lun,'(3f12.5)') diam.p(5).x,diam.p(5).y,diam.p(5).z
        write(lun,'(3f12.5)') diam.p(4).x,diam.p(4).y,diam.p(4).z
        write(lun,'(3f12.5)') diam.p(6).x,diam.p(6).y,diam.p(6).z
        call colorlevel(att(hit_trk(i).chan.devtype).color,col,1.6)
        write(lun,'(4f9.3)') col.r,col.g,col.b,1.
        write(lun,'(4f9.3)') col.r,col.g,col.b,1.
      enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:57  garren
c add rcs log line
c
