C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getInfoMaterial
C 
C Description:
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Julia Yarba
C Created:     Aug 1, 1997

      subroutine get_info_material(index, A, Z, density,
     *                                    radL, absL, dedx)

      implicit none

#include "material.inc"

c     Calling arguments 
c     Input :
      integer index
c     Output :
      real A, Z, density, radL, absL, dedx

c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      A = mtl_par(index).a
      Z = mtl_par(index).z
      density = mtl_par(index).density
      radL = mtl_par(index).rad_len
      absL = mtl_par(index).abs_len
      dedx = mtl_par(index).dedx

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
c Revision 1.1  1997/08/02 03:01:02  mkl
c Julia's utility routines for RealMaterial
c
c
