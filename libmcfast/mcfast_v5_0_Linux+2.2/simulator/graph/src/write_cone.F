      subroutine write_cone(itype,nsides,z0,zlen,rminl,rminh,
     +  rmaxl,rmaxh)
************************************************************************
*
*       write_cone
*
*       MCFAST Geomview graphics
*
*       Render a cone. (+,+) quadrant is not drawn.
*
************************************************************************
      implicit none
#include "const.inc"
#include "mcfast_db.inc"
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      integer lun, nsides, i, j, k, l, itype, nv, nsec, iz, nvert
      integer nvli1,nvli2,nvli3,nvli4,nvlo1,nvlo2,nvlo3,nvlo4
      integer nvhi1,nvhi2,nvhi3,nvhi4,nvho1,nvho2,nvho3,nvho4
      integer nsector, nfaces
      DFLOAT z0, zlen, rminl, rminh, rmaxl, rmaxh, dphi, z(2)
      DFLOAT r(2,2), rad, phi
*
      record /pt_s/ pt(2,2)
*
*-----------------------------------------------------------------------
*
      lun = lungraph
      dphi = 3.14159265*2/nsides
      z(1) = z0 - zlen/2.
      z(2) = z0 + zlen/2.
      r(1,1) = rminl
      r(1,2) = rminh
      r(2,1) = rmaxl
      r(2,2) = rmaxh
*
***     end faces
*
*       ordering of vertices:                     vtx indx  (is=nsides/4)
*         [lo z, inner r, 0->270->180->90 deg]    3*nsides/4 +1
*         [lo z, outer r, 90->180->270->0 deg]    3*nsides/4 +1
*         [hi z, inner r, 90->180->270->0 deg]    3*nsides/4 +1
*         [hi z, outer r, 0->270->180->90 deg]    3*nsides/4 +1
*                                             =2*(6*nsides/4 +2)
      write(lun,'(a)') 'OFF '
      nv = 6*nsides/4 + 2       ! sides for 3/4 of circle, plus 1, for inner+outer
      if (rminl.gt.0.0.and.rminh.gt.0.0) then
*         will write inner and outer cylinders
        nfaces = 6 + 2* 3*nsides/4
      else
*         will write outer cylinder only
        nfaces = 6 + 3*nsides/4
      endif
      write(lun,'(3i5)') 2*nv, nfaces, 0
      nvert=0
      do iz=1,2                 ! loop over lo, hi z
        do k=2,1,-1             ! loop over inner, outer r
          do 200 i=1, nsides    ! loop over sides
            if (iz.eq.1) then   ! lo z
              if (k.eq.1) then
                nsec = nsides-i+1
              else
                nsec = i
              endif
            else                ! hi z
              if (k.eq.2) then
                nsec = nsides-i+1
              else
                nsec = i
              endif
            endif
            phi = nsec*dphi
c            if (att(itype).visible.eq.it_cutaway.and.nsec.lt.nsides/4)
            if (nsec.lt.nsides/4)
     +        then
***             substitute for transparency: don't draw (0,0) quadrant
              goto 200
            endif
            nvert=nvert+1
            rad = r(k,iz)
            write(lun,'(3f9.3)') rad*cos(phi), rad*sin(phi), z(iz)
 200      enddo
        enddo
      enddo
      nvert = nvert/2
*       vertex indices, lo
      nvli1 = 0                 ! phi=0    inner
      nvli2 = nsides/4          !     270, inner
      nvli3 = nsides/2          !     180, inner
      nvli4 = 3*nsides/4        !      90, inner
      nvlo1 = nv-1              ! phi= 90, outer
      nvlo2 = nvlo1-nsides/4    !     180, outer
      nvlo3 = nvlo1-nsides/2    !     270, outer
      nvlo4 = nvli4+1           !       0, outer
*       vertex indices, hi
      nvhi1 = nvert + 0
      nvhi2 = nvert + nsides/4
      nvhi3 = nvert + nsides/2
      nvhi4 = nvert + 3*nsides/4
      nvho1 = nvert + nv-1
      nvho2 = nvert + nv-1-nsides/4
      nvho3 = nvert + nv-1-nsides/2
      nvho4 = nvert + 3*nsides/4+1
*
***     in order for geomview rendering to work reasonably,
***     subdivide faces by quadrant
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvli1,nvli2),
     +  (k,k=nvlo2,nvlo1-1)
      call write_final_vtx(itype,nvlo1)
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvli2,nvli3),
     +  (k,k=nvlo3,nvlo2-1)
      call write_final_vtx(itype,nvlo2)
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvli3,nvli4),
     +  (k,k=nvlo4,nvlo3-1)
      call write_final_vtx(itype,nvlo3)
*
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvhi1,nvhi2),
     +  (k,k=nvho2,nvho1-1)
      call write_final_vtx(itype,nvho1)
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvhi2,nvhi3),
     +  (k,k=nvho3,nvho2-1)
      call write_final_vtx(itype,nvho2)
      write(lun,'(i4,(30i4))') (nsides/4+1)*2,(k,k=nvhi3,nvhi4),
     +  (k,k=nvho4,nvho3-1)
      call write_final_vtx(itype,nvho3)
*
***     cannot use the simplest approach; geomview rendering screws up
c      write(lun,'(i4,(30i4))') nvert+1,(k,k=0,nvert-1),0 ! lo z end face
c      write(lun,'(i4,(30i4))') nvert+1,(k,k=nvert,nvert*2-1),nvert ! hi z

      nsector = 3*nsides/4 +1
      do i=1,3*nsides/4
*         outer cylinder
        write(lun,'(5i5,4f9.3)') 4,i-1,i,3*nsector-i-1,3*nsector-i,
     +  att(itype).color.r,att(itype).color.g,att(itype).color.b,
     +  att(itype).trans
*         inner cylinder
        if (rminl.gt.0.0.and.rminh.gt.0.0) then
          write(lun,'(5i5,4f9.3)') 4,nsector+i-1,nsector+i,
     +      4*nsector-i-1,4*nsector-i, ! inner
     +      att(itype).color.r,att(itype).color.g,att(itype).color.b,
     +      att(itype).trans
        endif
      enddo
      end

************************************************************************
      subroutine write_final_vtx(itype,nv)
      implicit none
#include "det_structure.inc"
#include "det_att_structure.inc"
#include "det_draw.inc"
      integer itype, nv
*
      write(lungraph,'(i5,4f9.3)') 
     +  nv,att(itype).color.r,att(itype).color.g,
     +  att(itype).color.b, att(itype).trans
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:25  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:29:59  garren
c add rcs log line
c
