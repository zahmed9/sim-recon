      integer function geo_in_tracking(xp)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  See if the point xp is withing the tracking region.
c
c  Inputs:
c
c  xp(3)        DFLOAT array
c               Position of point
c
c  Return:
c               0 if outside tracking region
c               1 if inside tracking region
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "track_region.inc"

c     Calling argument
      DFLOAT xp(3)

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

        if(xp(1) .lt. trk_reg.xmin .or. xp(1) .gt. trk_reg.xmax .or.
     *     xp(2) .lt. trk_reg.ymin .or. xp(2) .gt. trk_reg.ymax .or.
     *     xp(3) .lt. trk_reg.zmin .or. xp(3) .gt. trk_reg.zmax) then
          geo_in_tracking = 0
        else
          geo_in_tracking = 1
        endif

c     normal exit
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:23  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:29:43  garren
c add rcs log line
c
