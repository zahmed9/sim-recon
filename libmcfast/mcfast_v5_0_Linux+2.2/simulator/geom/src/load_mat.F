      subroutine load_mat
      implicit none
      integer i, j, imat, imatcmp(10)
      real rr(10), aa(10), aeff, zeff, density, abseff, radeff, dedx
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "material.inc"
      integer lenocc
      external lenocc
*
***     materials
      write(mcp_llpt,*) 'Loading materials and mixtures'

      imat = 0
      do i=1,n_obj_material
        imat = min(imat + 1,max_mtl)
        mtl_num = imat
        mtl_par(imat).name = material(i).name(:lenocc(material(i).name))
        mtl_par(imat).a = material(i).a
        mtl_par(imat).z = material(i).z
        mtl_par(imat).density = material(i).density
        mtl_par(imat).rad_len = material(i).radlen
        mtl_par(imat).abs_len = material(i).abslen
        if (mtl_par(imat).rad_len.gt.0.0) then
          mtl_par(imat).rad_inv = 1./mtl_par(imat).rad_len
        else
          mtl_par(imat).rad_inv = 0.
        endif
        if (material(i).abslen.gt.0.0) then
          mtl_par(imat).abs_inv = 1./material(i).abslen
        else
          mtl_par(imat).abs_inv = 0.
        endif
        if (material(i).collen.gt.0.0) then
          mtl_par(imat).coll_inv = 1./material(i).collen
        else
          mtl_par(imat).coll_inv = 0.
        endif
        mtl_par(imat).dedx = material(i).dedx
        mtl_par(imat).id(1) = i
        mtl_par(imat).ratio(1) = 1.
      enddo

*
***     mixtures
      do i=1,n_obj_mixture
        imat = min(imat + 1,max_mtl)
        mtl_num = imat
        mtl_par(imat).name = mixture(i).name(:lenocc(mixture(i).name))
        do j=1,mixture(i).nmat
          call getmat(mixture(i).matnames(j),imatcmp(j))
          mtl_par(imat).id(j) = imatcmp(j)
          aa(j) = mtl_par(imatcmp(j)).a
          rr(j) = mixture(i).prop(j)
          mtl_par(imat).ratio(j) = rr(j)
        enddo
        call create_mixture(mixture(i).nmat,imatcmp,rr,aa,
     &       aeff,zeff,density,abseff,radeff,dedx)
        mtl_par(imat).a        = aeff
        mtl_par(imat).z        = zeff
        mtl_par(imat).density  = density
        mtl_par(imat).coll_len = 0.
        mtl_par(imat).abs_len  = abseff
        mtl_par(imat).rad_len  = radeff
        mtl_par(imat).dedx     = dedx
        mtl_par(imat).coll_inv = 0.
        mtl_par(imat).abs_inv  = 1./abseff
        mtl_par(imat).rad_inv  = 1./radeff
      enddo
      end        

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:29:51  garren
c add rcs log line
c
