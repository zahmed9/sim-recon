      subroutine dsynv2(a,order,idim,ifail)
C
C dummy for calling CERN routine DSINV
C       
C a      - two dimensional array containing matrix to invert (read)
C        - a inverted (write)
C order  - order of the matrix (read)
c idim   - first dimension of a (read)
c ifail  - = 0 if all is cool (write)
C
C Created 10/10/94  A. Boehnlein

      implicit none
#include "const.inc"

C input/output       
      integer order,idim,ifail
      DFLOAT a(idim,*)
 
c
      call dsinv(order,a,idim,ifail)
      return
      end            

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:29  garren
c add rcs log line
c
