      subroutine get_detector_dimensions( rmax, zmin, zmax )

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  get largest volume info 
c
c  Inputs:
c
c  Outputs:
c
c     rmax = largest radius
c     zmin = smallest z
c     zmax = largest z
c
c  Return:
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "detector_region.inc"

c     Calling argument
      DFLOAT rmax, zmin, zmax

c     local variables
      DFLOAT r
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      rmax = 0
      zmin = 0
      zmax = 0

      ! first r
      r = sqrt( det_reg.xmin**2 + det_reg.ymin**2 )
      if( r.gt.rmax ) rmax = r
      r = sqrt( det_reg.xmax**2 + det_reg.ymax**2 )
      if( r.gt.rmax ) rmax = r

      ! then z
      if( det_reg.zmin .lt. zmin ) zmin = det_reg.zmin
      if( det_reg.zmax .gt. zmax ) zmax = det_reg.zmax

c     normal exit
      return
      end


c -----------------------------------------------
c questions, suggestions -- get on line 1!
c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:34  eugenio
c Initial revision
c
c Revision 1.2  1997/05/10 01:41:39  mkl
c minor adjustments as part of the bug hunt
c
c Revision 1.1  1997/05/09  06:36:56  mkl
c added get_detector_dimensions to make large enveloping volume for tracing.
c fixed curler tracing in forward direction.
c
c
