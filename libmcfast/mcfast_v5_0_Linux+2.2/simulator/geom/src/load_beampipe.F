      subroutine load_beampipe
      implicit none
      integer i, j, lenocc
      external lenocc
#include "mcfast_db.inc"
#include "mcp_luns.inc"
#include "beampipe.inc"
*
      if (n_obj_bpipe.eq.0) return
      
      beampipe_num = min(max_beampipe,n_obj_bpipe)
      
      do i = 1, beampipe_num

       beampipe_par(i).name = bpipe(i).name(:lenocc(bpipe(i).name))
       beampipe_par(i).rmin = bpipe(i).rmin
       beampipe_par(i).rmax = bpipe(i).rmax
       beampipe_par(i).zmin = bpipe(i).z0 - bpipe(i).zlen/2.
       beampipe_par(i).zmax = bpipe(i).z0 + bpipe(i).zlen/2.
       call getmat(bpipe(i).mat_fill,beampipe_par(i).material)
       do j=1,4
         call getmat(bpipe(i).matrbnd(j),beampipe_par(i).mat_boun(j))
         beampipe_par(i).thick_boun(j) = bpipe(i).bndrthk(j)
       enddo
*
       write(mcp_llpt,'(a,2f9.3,a,2f9.3)') ' Loading beam pipe "'//
     +  beampipe_par(i).name(:lenocc(beampipe_par(i).name))//
     +  '" rmin, rmax',
     +  beampipe_par(i).rmin, beampipe_par(i).rmax,' zmin, zmax',
     +  beampipe_par(i).zmin, beampipe_par(i).zmax
*
      enddo
*      
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:24  eugenio
c Initial revision
c
c Revision 1.6  1999/04/25 05:37:20  mcbride
c fix typo in index
c
c Revision 1.5  1999/04/24  22:39:20  mcbride
c update to allow multiple beampipes
c
c Revision 1.4  1997/04/04  20:29:48  garren
c add rcs log line
c
