C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getNContMaterials
C 
C Description:
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Julia Yarba
C Created:     Aug 1, 1997

      subroutine get_n_cont_materials(index, ncont)

      implicit none

#include "material.inc"

c     Calling arguments
c     Input :
      integer index
c     Output :
      integer ncont

c     Local variables 
      integer icont 

c++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      ncont = 0

      do icont = 1,max_mat_mix
       if (mtl_par(index).id(icont) .eq. 0) goto 100
       ncont = ncont + 1
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
