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
C Author:      Julia Yarba
C Created:     Mon March 22 1999

      subroutine get_emcal_gap_info_box( 
     * index, gap 
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
      real gap(4)

c ---------------- local variables -----------------------------

c -------------------- code ------------------------------------

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

      gap(1) = 0.
      gap(2) = 0.
      gap(3) = 0.
      gap(4) = 0.

      ! make sure index is ok
      if( index .gt. emcal_num .or. index .lt. 1) then
        print *, 'getEMCalInfo_Box: bad index=', index
        return
      endif

      if ( emcal_par(index).shape .ne. 'BOX' ) return
      
      gap(1) = emcal_par(index).xlimit_gap(1)
      gap(2) = emcal_par(index).xlimit_gap(2)
      gap(3) = emcal_par(index).ylimit_gap(1)
      gap(4) = emcal_par(index).ylimit_gap(2)

c report success
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
c Revision 1.2  1999/03/24 18:53:06  yarba_j
c minor cleanup
c
c Revision 1.1  1999/03/24  18:52:05  yarba_j
c routine to get info on inner gap for a box-shaped volume from fortran db
c
c

