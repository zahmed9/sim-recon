C -*- Fortran -*-
C
C Package:     Tracing
C Module:      ProductionTime
C 
C Description:
C       fortran interface routine:
C         return production time of particle from vertexing info
C
C Implimentation:
C       because I use a function, the return value has to be real
C       NOT DFLOAT, because it's not defined at the function prototype
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997
C RCS(Id)
C
C Revision history
C
C RCS(Log)

      real function productiontime( hep )
C ------------------------------------------------------------------
C   return production time of particle from vertexing info
C ------------------------------------------------------------------

      implicit none

c#include "const.inc"
#include "stdhep.inc"
#include "vtxhep.inc"

C ------------------------- calling variables ----------------------
C --------------------------- input --------------------------------
      integer hep                ! hep index

C --------------------------- output -------------------------------
      
C --------------------------- code ---------------------------------

      productiontime = vtx_pos( 4, ipvhep( hep ) )/ clight

      return
      end


c ======================================================================
c Questions, suggestions -- get on line 1!
c
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:34  eugenio
c Initial revision
c
c Revision 1.1  1997/07/03 03:34:02  mkl
c new approach: surfaces vs volumes; box tracing
c
c Revision 1.1.1.1  1997/03/14  22:52:33  mkl
c Imported sources for Martin Lohner s new c++ tracing code
c

