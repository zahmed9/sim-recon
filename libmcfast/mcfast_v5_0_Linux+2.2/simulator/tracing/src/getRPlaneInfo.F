C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getRPlaneInfo
C 
C Description: fortran interface to get rplane info out of common block
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997

      subroutine get_rplane_info( 
     * index,
     * ordered_index,
     * name,
     * type,
     * radl, dedx, coll, absp,
     * radius, zmin, zmax,
     * deviceIndexF, layerIndexF, wedgeIndexF
     * )

C -----------------------------------------------------------------------
C   return fortran common block info on rplanes
C -----------------------------------------------------------------------

#include "rplane.inc"

c --------------- calling parameters ---------------------------

c in
      integer index

c out
      integer ordered_index
      character*(*) name
      integer type
      real radl, dedx, coll, absp
      real radius, zmin, zmax
      integer deviceIndexF, layerIndexF, wedgeIndexF

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c      print *, 'Here in getRPlaneInfo'

      ! make sure index is ok
      if( index .gt. rpln_num .or. index .lt. 1) then
        print *, 'getRPlaneInfo: bad index=', index
        return
      endif

c fill info from common blocks
      ordered_index = rpln_up(index)

      name          = rpln_par(ordered_index).name
      type          = rpln_par(ordered_index).type

      radl          = rpln_par(ordered_index).radl
      dedx          = rpln_par(ordered_index).dedx
      coll          = rpln_par(ordered_index).col
      absp          = rpln_par(ordered_index).abs

      radius        = rpln_par(ordered_index).radius
      zmin          = rpln_par(ordered_index).zmin
      zmax          = rpln_par(ordered_index).zmax

      deviceIndexF  = rpln_par(ordered_index).pos(1)
      layerIndexF   = rpln_par(ordered_index).pos(2)
      wedgeIndexF   = rpln_par(ordered_index).pos(3)

c report success
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
c Revision 1.4  1998/02/16 04:33:44  mkl
c first version of 2ndary interactions
c
c Revision 1.3  1997/11/22  20:26:38  mkl
c keep track of fortran name of planes
c
c Revision 1.2  1997/08/23  01:10:20  mkl
c toward volume-based tracing
c
c Revision 1.1  1997/07/03  03:34:01  mkl
c new approach: surfaces vs volumes; box tracing
c
c

