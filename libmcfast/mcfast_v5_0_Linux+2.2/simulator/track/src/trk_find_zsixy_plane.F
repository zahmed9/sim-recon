      subroutine trk_find_zsixy_plane(w, dev, lyr, lstrike, eta)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Find which silicon plane a track went through
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  dev        integer variable
c             Silicon plane array device number
c
c  Outputs:
c
c  lyr        integer variable
c             Number of plane that was hit
c
c  lstrike    logical variable
c             TRUE if track falls within plane boundaries
c
c  eta(3)     DFLOAT variable
c             Direction cosines normal to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "sixy_disk.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer dev, lyr
      logical lstrike
      DFLOAT eta(3)
      record /wtrack_struct/ w

c     Local variables
      integer ilyr
      real xmin,xmax,ymin,ymax,xmin_gap,xmax_gap,ymin_gap,ymax_gap

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Compute which plane was hit based on z position of hit

c      lyr = 0
c      do ilyr=1,sixy_par(dev).numlyr
c        if (w.z.ge.sixy_par(dev).lyr(ilyr).z.and.w.z.le.sixy_par(dev)
c     &.lyr(ilyr).z+sixy_par(dev).lyr(ilyr).thick) then
c          lyr = ilyr
c        end if
c      end do

      lstrike = .false.

      xmin = sixy_par(dev).lyr(lyr).xmin
      xmax = sixy_par(dev).lyr(lyr).xmax
      ymin = sixy_par(dev).lyr(lyr).ymin
      ymax = sixy_par(dev).lyr(lyr).ymax
      xmin_gap = sixy_par(dev).lyr(lyr).xmin_gap
      xmax_gap = sixy_par(dev).lyr(lyr).xmax_gap
      ymin_gap = sixy_par(dev).lyr(lyr).ymin_gap
      ymax_gap = sixy_par(dev).lyr(lyr).ymax_gap

      if (lyr.ne.0) then
        lstrike = (w.x.ge.xmin .and. w.x.le.xmax) .and. 
     *          (w.y.ge.ymin .and. w.y.le.ymax) .and. 
     *          ((w.x.ge.xmax_gap .or. w.x.le.xmin_gap) .or.
     *          (w.y.ge.ymax_gap .or. w.y.le.ymin_gap))
      end if

      eta(1) = 0.
      eta(2) = 0.
      eta(3) = 1.

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:36  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:24  garren
c add rcs log line
c
