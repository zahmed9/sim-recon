      subroutine getmat(chmat,imat)
*
      implicit none
      character*(*) chmat
      integer imat, i
      integer lenocc
      external lenocc
#include "mcp_luns.inc"
#include "material.inc"
*
      imat = 0
      if (lenocc(chmat).eq.0.or.chmat(1:1).eq.'-') return
*
      do i=1,mtl_num
c        print *,mtl_par(i).name(:lenocc(mtl_par(i).name))
        if (mtl_par(i).name(:lenocc(mtl_par(i).name)) .eq.
     +    chmat(:lenocc(chmat)) ) then
          imat = i
          goto 999
        endif
      enddo
 999  if (imat.eq.0) then
        write (mcp_llpt,1000) chmat(:lenocc(chmat))
 1000   format('GETMAT error: Material ',a,' not found.')
      endif
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:47  garren
c add rcs log line
c
