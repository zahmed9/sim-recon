C -*- Fortran -*-
C
C Package:     Tracing
C Module:      findBsilPlanePos
C 
C Description:
C       fortran interface routine:
C          find positions of barrel silicon wavers from common block info
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Jan 31, 1997

      subroutine find_bsil_plane_pos( dev, lyr, plane, position )
C ----------------------------------------------------------------------
C   return position from info in sib_par common block
C ----------------------------------------------------------------------

      implicit none

#include "const.inc"
#include "si_barrel.inc"

C ------------------ calling variables ---------------------------------
C ----------------------- input ----------------------------------------
      integer dev, lyr, plane
C ----------------------- ouput ----------------------------------------
      DFLOAT position(3)

C ----------------------- code -----------------------------------------

      position(1) = sib_par(dev).lyr(lyr).plane(plane).xpos(1)
      position(2) = sib_par(dev).lyr(lyr).plane(plane).xpos(2)
      position(3) = sib_par(dev).lyr(lyr).plane(plane).xpos(3)

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
c Revision 1.1  1997/07/03 03:34:00  mkl
c new approach: surfaces vs volumes; box tracing
c
c

