C -*- Fortran -*-
C
C Package:     Tracing
C Module:      getDipoleInfo
C 
C Description: fortran interface to get dipole info out of common block
C
C Implimentation:
C     <Notes on implimentation>
C
C Author:      Martin Lohner
C Created:     June 26, 1997

      subroutine get_dipole_info( 
     * index,
     * name,
     * xmin, xmax,
     * ymin, ymax,
     * zmin, zmax,
     * dircos
     * )

C -----------------------------------------------------------------------
C   return fortran common block info on dipoles
C -----------------------------------------------------------------------

#include "dipole.inc"

c --------------- calling parameters ---------------------------

c in
      integer index

c out
      character*(*) name        ! device name
      real xmin                 !xmin of gap
      real xmax                 !xmax of gap
      real ymin                 !ymin of gap
      real ymax                 !ymax of gap
      real zmin                 !zmin of magnetic region
      real zmax                 !zmax of magnetic region
c      real Bfield               !Magnitude of B in Tesla
      real dircos(3)            !Direction cosines of B field
c      real ptkick               !Pt kick of magnet = 0.3*B*(zmax - zmin)
c      character*40 name         !Name of device
c      integer mat_fill          !material filling dipole's "gap"
c      real thick_boun(6)        !thickness of boundries
c      integer mat_boun(6)       !materails for boundries                      

c ---------------- local variables -----------------------------
      integer i

c -------------------- code ------------------------------------

c      print *, 'Here in getDipoleInfo'

      ! make sure index is ok
      if( index .gt. dip_num .or. index .lt. 1) then
        print *, 'getDipoleInfo: bad index=', index
        return
      endif

c fill info from common blocks
      xmin = dip_par(index).xmin                 !xmin of gap
      xmax = dip_par(index).xmax                 !xmax of gap
      ymin = dip_par(index).ymin                 !ymin of gap
      ymax = dip_par(index).ymax                 !ymax of gap
      zmin = dip_par(index).zmin                 !zmin of magnetic region
      zmax = dip_par(index).zmax                 !zmax of magnetic region

c      real Bfield               !Magnitude of B in Tesla
      do i=1,3
        dircos(i) = dip_par(index).dircos(i) !Direction cosines of B field
      enddo
c      real ptkick               !Pt kick of magnet = 0.3*B*(zmax - zmin)

      name = dip_par(index).name ! name of device
c      integer mat_fill          !material filling dipole's "gap"
c      real thick_boun(6)        !thickness of boundries
c      integer mat_boun(6)       !materails for boundries                      

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
c Revision 1.3  1997/11/22 20:26:38  mkl
c keep track of fortran name of planes
c
c Revision 1.2  1997/08/23  01:10:19  mkl
c toward volume-based tracing
c
c Revision 1.1  1997/07/03  03:34:00  mkl
c new approach: surfaces vs volumes; box tracing
c
c

