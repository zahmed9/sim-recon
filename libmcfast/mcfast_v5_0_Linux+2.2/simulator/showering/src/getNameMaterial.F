C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getNameMaterial
C 
C Description:
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Julia Yarba
C Created:     Aug 1, 1997

      subroutine get_name_material( imat, name )

      implicit none

#include "material.inc"

c     Calling arguments
      integer imat
      character*(*) name

c     Local variables : none

c+++++++++++++++++++++++++++++++++++++++++++++++

      name = mtl_par(imat).name

      return
      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:30  eugenio
c Initial revision
c
c Revision 1.1  1997/08/02 03:01:03  mkl
c Julia's utility routines for RealMaterial
c
c
