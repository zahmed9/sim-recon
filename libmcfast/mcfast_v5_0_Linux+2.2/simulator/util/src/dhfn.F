      subroutine dhfn(id,x)
C
c     double precision interface with hfn
c    
c     created Aug 18, 1994 Amber Boehnlein
c
c     MUST USE with dhbookn!

      implicit none
#include "const.inc"
c     inputs to dhfn
      integer id   !ntuple id
      DFLOAT x(*)  !array of values destined for ntuple
      integer nvar1        !number of values
      common/ntuple/nvar1
      
      integer max_entry 
      parameter (max_entry= 1000)
      real sng_x(max_entry)
      integer i

      if (nvar1.gt.max_entry)then 
        print *,
     &  'Warning from dhfn, array truncated'
        nvar1 = max_entry
      endif
      
      do i = 1,nvar1
        sng_x(i) = sngl(x(i))
      enddo

      call hfn(id,sng_x)   
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:27  garren
c add rcs log line
c
