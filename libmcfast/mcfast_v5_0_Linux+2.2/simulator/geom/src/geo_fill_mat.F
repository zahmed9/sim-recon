      subroutine geo_fill_mat(keyword,nstart,i_fill,buffer,mat_name)
c
      implicit none
c
#include "mcp_luns.inc"
#include "material.inc"
c
      character*(*) keyword
c
      integer nstart, i_fill
c
      real buffer(*)
c
      character*(*) mat_name
c
      integer num_mat
c
      integer i,nmatmix
c
      integer id_mat(max_mat_mix)
      real aa(max_mat_mix), rr(max_mat_mix)
      real aeff, zeff, density, abseff, radeff, dedx
c
c
c
      if (nstart .eq. 1) then
       num_mat = mtl_num + 1
      else
       num_mat = mtl_num
      end if
c
       do i = 1,max_mat_mix
        id_mat(i) = 0
        aa(i) = 0.
        rr(i) = 0.
       end do
c
      if (num_mat .gt. max_mtl) num_mat = max_mtl
c
c
c
      if (keyword .eq. 'MATERIAL') then
c
       if (mat_name .ne. ' ' .and. nstart .eq. 1) then
        mtl_par(num_mat).name = mat_name
       end if
c
       if (i_fill .eq. 1) then
        mtl_par(num_mat).a = buffer(3)
        mtl_par(num_mat).z = buffer(4)
        mtl_par(num_mat).density = buffer(5)
        mtl_par(num_mat).rad_len = buffer(6) 
        if (buffer(6) .gt. 0.0) then
         mtl_par(num_mat).rad_inv = 1. / buffer(6)
        else
         mtl_par(num_mat).rad_inv = 0.0
        end if
        mtl_par(num_mat).abs_len = buffer(7) 
        if (buffer(7) .gt. 0.0) then
         mtl_par(num_mat).abs_inv = 1. / buffer(7)
        else
         mtl_par(num_mat).abs_inv = 0.0
        end if
        mtl_par(num_mat).coll_len = buffer(8) 
        if (buffer(8) .gt. 0.0) then
         mtl_par(num_mat).coll_inv = 1. / buffer(8)
        else
         mtl_par(num_mat).coll_inv = 0.0
        end if
        mtl_par(num_mat).dedx = buffer(9) 
        mtl_par(num_mat).id(1) = num_mat
        mtl_par(num_mat).ratio(1) = 1.
       end if
c
      end if
c
c
c
      if (keyword .eq. 'MIXTURE') then
c
       nmatmix = 0
c
       if (mat_name .ne. ' ') then
c
        if (nstart .eq. 1) then
         mtl_par(num_mat).name = mat_name
        else if (nstart .gt. 2) then
         do i = 1,num_mat-1
          if (mtl_par(i).name .eq. mat_name) then
           mtl_par(num_mat).id(nstart-2) = i
           goto 100
          end if
         end do
c
 100     if (mtl_par(num_mat).id(nstart-2) .le. 0 .or. 
     &       mtl_par(num_mat).id(nstart-2) .gt. num_mat) then
          write(mcp_llpt,5000) nstart, id_mat(nstart-2)
          return
         endif
c
        end if
c
       end if
c
       if (i_fill .eq. 1) then
        nmatmix = int(buffer(3))
        do i = 1,nmatmix
         id_mat(i) = mtl_par(num_mat).id(i)
         aa(i)     = mtl_par(id_mat(i)).a
         rr(i) = buffer(i+nmatmix+3)
         mtl_par(num_mat).ratio(i) = rr(i)
        end do
c
        call create_mixture(nmatmix,id_mat,rr,aa,
     &       aeff,zeff,density,abseff,radeff,dedx)
c
        mtl_par(num_mat).a        = aeff
        mtl_par(num_mat).z        = zeff
        mtl_par(num_mat).density  = density
        mtl_par(num_mat).coll_len = 0.
        mtl_par(num_mat).abs_len  = abseff
        mtl_par(num_mat).rad_len  = radeff
        mtl_par(num_mat).dedx     = dedx
        mtl_par(num_mat).coll_inv = 0.
        mtl_par(num_mat).abs_inv  = 1./abseff
        mtl_par(num_mat).rad_inv  = 1./radeff
c
       end if
c
      end if
c
      mtl_num = num_mat
c
      return
c
 5000 format(' MIXTURE: UNKNOWN MATERAIL AT POS.' i4,
     &       'id_mat(pos-2)', i4)
c
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:22  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:37  garren
c add rcs log line
c

