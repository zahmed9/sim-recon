C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getZPlaneInfo
C 
C Description: fortran interface to get zplane info out of common block
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Feb 23, 1997

C -----------------------------------------------------------------------

      subroutine get_zplane_info( 
     * index,
     * ordered_index,
     * name,
     * type, shape,
     * radl, dedx, coll, absp,
     * z, rmin, rmax, xmin, xmax, ymin, ymax,
     * deviceIndexF, layerIndexF, wedgeIndexF
     * )

C -----------------------------------------------------------------------
C   return fortran common block info on zplanes
C -----------------------------------------------------------------------

#include "zplane.inc"

c --------------- calling parameters ---------------------------

c in
      integer index

c out
      integer ordered_index
      character*(*) name
      integer type, shape
      real radl, dedx, coll, absp
      real z, rmin, rmax, xmin, xmax, ymin, ymax
      integer deviceIndexF, layerIndexF, wedgeIndexF

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c      print *, 'Here in getFortranUserSettings'

      ! make sure index is ok
      if( index .gt. zpln_num .or. index .lt. 1) then
        print *, 'getZPlaneInfo: bad index=', index
        return
      endif

c fill info from common blocks
      ordered_index = zpln_up(index)

      name          = zpln_par(ordered_index).name
      type          = zpln_par(ordered_index).type 
      shape         = zpln_par(ordered_index).shape

      radl          = zpln_par(ordered_index).radl
      dedx          = zpln_par(ordered_index).dedx
      coll          = zpln_par(ordered_index).col
      absp          = zpln_par(ordered_index).abs

      z             = zpln_par(ordered_index).z
      rmin          = zpln_par(ordered_index).rmin
      rmax          = zpln_par(ordered_index).rmax
      xmin          = zpln_par(ordered_index).xmin
      xmax          = zpln_par(ordered_index).xmax
      ymin          = zpln_par(ordered_index).ymin
      ymax          = zpln_par(ordered_index).ymax
 
      deviceIndexF  = zpln_par(ordered_index).pos(1)
      layerIndexF   = zpln_par(ordered_index).pos(2)
      wedgeIndexF   = zpln_par(ordered_index).pos(3)

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
c Revision 1.4  1998/02/16 04:33:45  mkl
c first version of 2ndary interactions
c
c Revision 1.3  1997/11/22  20:26:39  mkl
c keep track of fortran name of planes
c
c Revision 1.2  1997/08/23  01:10:21  mkl
c toward volume-based tracing
c
c Revision 1.1  1997/07/03  03:34:02  mkl
c new approach: surfaces vs volumes; box tracing
c
c

