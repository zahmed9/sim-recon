C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getNameLength
C 
C Description:
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Julia Yarba
C Created:     Aug 1, 1997

      subroutine get_name_length( imat, length )
 
      implicit none

#include "material.inc"

c     Calling arguments :
      integer imat, length

c     Local variables :
      integer icount

c++++++++++++++++++++++++++++++++++++++++++++++++++

      do icount = len(mtl_par(imat).name),1,-1
       if (mtl_par(imat).name(icount:icount) .ne. ' ') then
        length = icount
        goto 100
       end if
      end do

  100 return
      end



c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:30  eugenio
c Initial revision
c
c Revision 1.1  1997/08/02 03:01:02  mkl
c Julia's utility routines for RealMaterial
c
c
