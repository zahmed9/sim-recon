      subroutine det_geom(lun)
************************************************************************
*
*       det_geom
*
*       MCFAST Geomview graphics
*
*       Output the detector geometry for graphics purposes.
*       Uses Geomview.
*
*       N.B. normal to surfaces is computed from RH rule applied to
*       order of vertices.
*
************************************************************************
      implicit none
*
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "sixy_disk.inc"
#include "si_barrel.inc"
#include "sicir_disk.inc"
#include "det_draw.inc"
      integer i, j, k, lun, itype, ipt, idet, ipl
      DFLOAT z(2), xmin,xmax,ymin,ymax,xming,xmaxg,yming,ymaxg
      DFLOAT z0, phi, rmin, rmax, dphi, phi0
      real pipewid
      parameter (pipewid = 20.)
      logical x2, y2
      integer nsides
      record /quad_s/ quad
*
*-----------------------------------------------------------------------
*
      if (.not.geomview_out) return

      nsides = 48
      if (mod(nsides,4).ne.0) nsides=int(nsides/4)*4

      if (lun.eq.0) call freeunit(lun)
      lungraph = lun
      if (lun.ne.6)
     +  open(unit=lun,file=geomview_file_out,form='formatted',
     +       status='UNKNOWN')
*
      call open_graphics
*
      do 100 i=1,ndetst
        itype = detst(i).itype
        if (att(itype).visible.eq.it_invisible) goto 100
*
        call write_det_geom(itype,detst(i).name)
*
        z(1) = detst(i).z0 - detst(i).zlen/2.
        z(2) = detst(i).z0 + detst(i).zlen/2.
        if (detst(i).ishape.eq.it_cylinder) then
*****       cylinder, cone      ***************************************
          call write_cone(itype,nsides,detst(i).z0,detst(i).zlen,
     +      detst(i).rmin,detst(i).rmin,detst(i).rmax,detst(i).rmax)
        else if (detst(i).ishape.eq.it_cone) then
          call write_cone(itype,nsides,detst(i).z0,detst(i).zlen,
     +      detst(i).rmin,detst(i).rminf,detst(i).rmax,detst(i).rmaxf)
        else if (detst(i).ishape.eq.it_proj_cylinder) then
*****       box      **************************************************
        else if (detst(i).ishape.eq.it_box) then
          write(lun,'(a)') 'OFF'
          if (detst(i).xmin*detst(i).xmax.gt.0.
     +      .and.detst(i).ymin*detst(i).ymax.gt.0.) then
*****         simple box         ******
            xmin = detst(i).xmin
            xmax = detst(i).xmax
            ymin = detst(i).ymin
            ymax = detst(i).ymax
*
*             vertices: 23  67
*                       01  45
*
            write(lun,*) '8 6 0'
            do j=1,2
              write(lun,1001) xmin, ymin, z(j) ! vertices
              write(lun,1001) xmax, ymin, z(j)
              write(lun,1001) xmin, ymax, z(j)
              write(lun,1001) xmax, ymax, z(j)
 1001         format(3f9.3)
            enddo
            call write_vertices(itype,'4 0 1 3 2')
            call write_vertices(itype,'4 4 6 7 5')
            call write_vertices(itype,'4 0 4 5 1')
            call write_vertices(itype,'4 1 5 7 3')
            call write_vertices(itype,'4 2 3 7 6')
            call write_vertices(itype,'4 0 2 6 4')
 1000       format(a,4f6.3)
          else
*****         open box. Split in two.    *********
***           left
*             5  4
*                
*                3   2
*             0      1
*
            write(lun,*) '12 6 0'
            do j=1,2
              write(lun,1001) detst(i).xmin, detst(i).ymin, z(j) ! vertices
              write(lun,1001) detst(i).xmax, detst(i).ymin, z(j)
              write(lun,1001) detst(i).xmax, -pipewid, z(j)
              write(lun,1001) -pipewid, -pipewid, z(j)
              write(lun,1001) -pipewid, detst(i).ymax, z(j)
              write(lun,1001) detst(i).xmin, detst(i).ymax, z(j)
            enddo
***           outer edges
            call write_vertices(itype,'4 1 0 6 7')
            call write_vertices(itype,'4 2 1 7 8')
            call write_vertices(itype,'4 5 4 10 11')
            call write_vertices(itype,'4 0 5 11 6')
***           faces
            call write_vertices(itype,'6 0 1 2 3 4 5')
            call write_vertices(itype,'6 11 10 9 8 7 6')
***           right
*            3   2
*            4 5
*              0 1  
*
            if (att(itype).visible.ne.it_cutaway) then
              write(lun,*) '12 4 0'
              do j=1,2
                write(lun,1001) pipewid, -pipewid, z(j) ! vertices
                write(lun,1001) detst(i).xmax, -pipewid, z(j)
                write(lun,1001) detst(i).xmax, detst(i).ymax, z(j)
                write(lun,1001) -pipewid, detst(i).ymax, z(j)
                write(lun,1001) -pipewid, pipewid, z(j)
                write(lun,1001) pipewid, pipewid, z(j)
              enddo
***             outer edges
              call write_vertices(itype,'4 2 1 7 8')
              call write_vertices(itype,'4 3 2 8 9')
***             faces
              call write_vertices(itype,'6 0 1 2 3 4 5')
              call write_vertices(itype,'6 11 10 9 8 7 6')
            endif
          endif
        else if (detst(i).ishape.eq.it_sibarrel) then
*****       sibarrel      **************************************************
          ipt = detst(i).ipt
          do j=1,sib_par(ipt).numlyr
            do k=1,sib_par(ipt).lyr(j).numplane
              phi = sib_par(ipt).lyr(j).plane(k).beta
              if (att(itype).visible.ne.it_cutaway.or.
     +          (phi.lt.0.0.or.phi.gt.pi/2.)) then
              
***               set up quad coordinates for plane at phi=0
                quad.p(1).x = sib_par(ipt).lyr(j).plane(k).delta_min
                quad.p(1).y = sib_par(ipt).lyr(j).plane(k).dmax
                quad.p(1).z = sib_par(ipt).lyr(j).plane(k).zmin
*                 
                quad.p(2).x = quad.p(1).x
                quad.p(2).y = sib_par(ipt).lyr(j).plane(k).dmin
                quad.p(2).z = quad.p(1).z
*                 
                quad.p(3).x = quad.p(1).x
                quad.p(3).y = quad.p(2).y
                quad.p(3).z = sib_par(ipt).lyr(j).plane(k).zmax
*                 
                quad.p(4).x = quad.p(1).x
                quad.p(4).y = sib_par(ipt).lyr(j).plane(k).dmax
                quad.p(4).z = quad.p(3).z
***               rotate quad to desired phi
                call quad_phirot(quad,phi)
***               draw quad
                call drawquad(itype,quad)
              endif
            enddo
          enddo
        else if (detst(i).ishape.eq.it_sidisk) then
*****       sidisk      **************************************************
          ipt = detst(i).ipt
***         use only the first layer (all layers are at same z)
          phi0 = sicir_par(ipt).lyr(1).phi(1)
          do k=1,sicir_par(ipt).lyr(1).numwedge
            phi = phi0+(k-1)*pi*2./sicir_par(ipt).lyr(1).numwedge
            if (att(itype).visible.ne.it_cutaway.or.
     +        (phi.lt.0.0.or.phi.gt.pi/2.)) then
              rmin = sicir_par(ipt).lyr(1).wedge(k).rmin
              rmax = sicir_par(ipt).lyr(1).wedge(k).rmax
              dphi = sicir_par(ipt).lyr(1).wedge(k).d_phi/2.
***             set up quad coordinates for wedge at phi=0
              quad.p(1).x = sicir_par(ipt).lyr(1).wedge(k).rmin
              quad.p(1).y = 
     +          sicir_par(ipt).lyr(1).wedge(k).rmin*tan(dphi)
              quad.p(1).z = sicir_par(ipt).lyr(1).wedge(k).z
*               
              quad.p(2).x = quad.p(1).x
              quad.p(2).y = -quad.p(1).y
              quad.p(2).z = quad.p(1).z
*               
              quad.p(3).x = sicir_par(ipt).lyr(1).wedge(k).rmax
              quad.p(3).y = 
     +          -sicir_par(ipt).lyr(1).wedge(k).rmax*tan(dphi)
              quad.p(3).z = quad.p(1).z
*               
              quad.p(4).x = quad.p(3).x
              quad.p(4).y = -quad.p(3).y
              quad.p(4).z = quad.p(1).z
***             rotate quad to desired phi
              call quad_phirot(quad,phi)
***             draw quad
              call drawquad(itype,quad)
            endif
          enddo
        else if (detst(i).ishape.eq.it_sixy) then
*****       sixy        **************************************************
          ipt = detst(i).ipt
          do j=1,sixy_par(ipt).numlyr
            xmin = sixy_par(ipt).lyr(j).xmin
            xmax = sixy_par(ipt).lyr(j).xmax
            ymin = sixy_par(ipt).lyr(j).ymin
            ymax = sixy_par(ipt).lyr(j).ymax
            xming = sixy_par(ipt).lyr(j).xmin_gap
            xmaxg = sixy_par(ipt).lyr(j).xmax_gap
            yming = sixy_par(ipt).lyr(j).ymin_gap
            ymaxg = sixy_par(ipt).lyr(j).ymax_gap
            z0 = sixy_par(ipt).lyr(j).z
*
            x2 = .false.
            y2 = .false.
            if (xming.gt.xmin.and.xmaxg.lt.xmax) x2 = .true.
            if (yming.gt.ymin.and.ymaxg.lt.ymax) y2 = .true.
            if (x2.and.y2) then
              call write_xycell(itype,xmin,xming,ymin,yming,z0)
              call write_xycell(itype,xmaxg,xmax,ymin,yming,z0)
              call write_xycell(itype,xmin,xming,ymaxg,ymax,z0)
              call write_xycell(itype,xmaxg,xmax,ymaxg,ymax,z0)
            else if (x2) then
              call write_xycell(itype,xmin,xming,ymin,ymax,z0)
              call write_xycell(itype,xmaxg,xmax,ymin,ymax,z0)
            else if (y2) then
              call write_xycell(itype,xmin,xmax,ymin,yming,z0)
              call write_xycell(itype,xmin,xmax,ymaxg,ymax,z0)
            endif
          enddo
        endif
*
        call close_det_geom(detst(i).name)
*
 100  enddo
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:56  garren
c add rcs log line
c
