      subroutine dhbookn(id,chtitl,nvar,chrzpa,nprime,tags) 

c     double precision interface with hbookn
c    
c     created Aug 18, 1994 Amber Boehnlein
c
c     MUST USE with dhfn!

      implicit none
#include "const.inc"
c     inputs to dhfn

C     inputs to dhbookn

      integer id          !ntuple id
      character*(*) chtitl   !ntuple title
      integer nvar        !number of values
      character*(*) chrzpa   !character string of options
      integer nprime      !bank length
      character*10 tags(*)  !array of tags


c save the number of variables for use in dhfn
      integer nvar1
      common/ntuple/nvar1
      
      nvar1 = nvar
      call hbookn(id,chtitl,nvar,chrzpa,nprime,tags)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:25  garren
c add rcs log line
c
