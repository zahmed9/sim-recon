C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getContIndexAndRatio
C 
C Description:
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Julia Yarba
C Created:     Aug 1, 1997

      subroutine get_cont_index_and_ratio(index, icont,
     *                                    indexCont, ratioCont)

      implicit none

#include "material.inc"

c     Calling arguments
c     Input :
      integer index, icont
c     Output :
      integer indexCont
      real    ratioCont

c++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      indexCont = mtl_par(index).id(icont)
      ratioCont = mtl_par(index).ratio(icont)

      return
      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:29  eugenio
c Initial revision
c
c Revision 1.1  1997/08/02 03:01:01  mkl
c Julia's utility routines for RealMaterial
c
c
