      integer function geo_in_detector(xp)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  See if the point xp is within the detector region.
c
c  Inputs:
c
c  xp(3)        DFLOAT array
c               Position of point
c
c  Return:
c               0 if outside detector region
c               1 if inside detector region
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "detector_region.inc"

c     Calling argument
      DFLOAT xp(3)

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        if(xp(1) .lt. det_reg.xmin .or. xp(1) .gt. det_reg.xmax .or.
     *     xp(2) .lt. det_reg.ymin .or. xp(2) .gt. det_reg.ymax .or.
     *     xp(3) .lt. det_reg.zmin .or. xp(3) .gt. det_reg.zmax) then
          geo_in_detector = 0
        else
          geo_in_detector = 1
        endif

c     normal exit
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:42  garren
c add rcs log line
c
