C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getEMCalInfo_Box
C 
C Description: fortran interface to get Box EMCal info out of common block
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     Mon Feb 15 1999

      subroutine get_emcal_info_box( 
     * index,
     * name,
     * shape_type, direction_type,
     * xmin, xmax, ymin, ymax, zmin, zmax,
     * material_index, active_material_index
     * )

      implicit none

C -----------------------------------------------------------------------
C   return fortran common block info on rplanes
C -----------------------------------------------------------------------

#include "emcal.inc"

c --------------- calling parameters ---------------------------

c in
      integer index

c out
      character*(*) name
      integer shape_type, direction_type
      real xmin, xmax, ymin, ymax, zmin, zmax
      integer material_index, active_material_index

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

c      print *, 'Here in getEMCalInfo_Box'

c fill info from common blocks
c      structure /emcal_struct/
c        integer type            !1 => barrel, 2 => forw.
c        integer seg_type        !0 eta-phi segmentation, 1 x-y segmentation
c        character*4 shape       !shape name (can be BOX, TUBE or CONE)
c        real rmin(2)            !rmin at zmin and zmax (for BOX/CONE)
c        real rmax(2)            !rmax at zmin and zmia (for BOX/CONE)
c        real xlimit(2)          !xmin,xmax (forBOX)
c        real ylimit(2)          !ymin,ymax (forBOX)
c        real xlimit_gap(2)      !inner gap xmin,xmax (forBOX)
c        real ylimit_gap(2)      !inner gap ymin,ymax (forBOX)
c        real zmin               !
c        real zmax               !
c        real eta_min            !Min eta
c        real eta_max            !Max eta
c        integer ncoor1          !# of phi or x segments
c        integer ncoor2          !# of eta or y segments
c        integer active_material !Active medium (important for sampling calorimeters)
c        ...
c        character*40 name       ! name
c ----------------------------------

      ! make sure index is ok
      if( index .gt. emcal_num .or. index .lt. 1) then
        print *, 'getEMCalInfo_Box: bad index=', index
        return
      endif

      ! get name
      name = emcal_par(index).name

      ! translate shape to easily-identifiable number
      ! ugly: please make sure the coding agrees with the 
      !       ShapeType in Volume.hh
      shape_type = 0
      if (emcal_par(index).shape .eq. 'BOX')  shape_type = 1
      if (emcal_par(index).shape .eq. 'TUBE') shape_type = 2
      if (emcal_par(index).shape .eq. 'CONE') shape_type = 3

      if( shape_type .ne. 1 ) then
         print *, 'not a box; exiting...'
         stop
      endif

      ! 1=>barrel, 2=>forward
      direction_type = emcal_par(index).type

      ! for now only record TUBE parameters
      xmin = emcal_par(index).xlimit(1)
      xmax = emcal_par(index).xlimit(2)
      ymin = emcal_par(index).ylimit(1)
      ymax = emcal_par(index).ylimit(2)
      zmin = emcal_par(index).zmin
      zmax = emcal_par(index).zmax

      !print *, ' rmin=', rmin, ' rmax=', rmax, 
      !*         ' zmin=', zmin, ' zmax=', zmax

      ! material indices
      material_index        = emcal_par(index).material
      active_material_index = emcal_par(index).active_material
      
c report success
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
c Revision 1.2  1999/02/16 23:51:55  yarba_j
c minor cleanup
c
c Revision 1.1  1999/02/15  19:04:17  mkl
c added Box-shaped Calorimeters
c
c
c

