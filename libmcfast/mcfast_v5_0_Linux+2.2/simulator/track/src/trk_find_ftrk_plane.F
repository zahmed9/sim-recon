      subroutine trk_find_ftrk_plane(w, dev, lyr, lstrike, eta)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Find where a track went through FTRK detector
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  dev        integer variable
c             FTRK detector device number
c
c  lyr        integer variable
c             Number of plane that was hit
c
c  Outputs:
c
c  lstrike    logical variable
c             TRUE if track falls within plane boundaries
c
c  eta(3)     DFLOAT variable
c             Direction cosines normal to plane
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "for_trk.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer dev, lyr
      logical lstrike
      DFLOAT eta(3)
      record /wtrack_struct/ w

c     Local variables
      integer ilyr, type
      real xmin,xmax,ymin,ymax,xmin_gap,xmax_gap,ymin_gap,ymax_gap
      real xl, yl

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Compute if plane was hit based on x,y position of hit

      lstrike = .false.

      if (lyr .le. 0 .or. lyr .gt. ftrk_par(dev).nlyr) return

      type = ftrk_par(dev).lyr(lyr).type
      xmin = ftrk_par(dev).lyr(lyr).xmin
      xmax = ftrk_par(dev).lyr(lyr).xmax
      ymin = ftrk_par(dev).lyr(lyr).ymin
      ymax = ftrk_par(dev).lyr(lyr).ymax
      xmin_gap = ftrk_par(dev).lyr(lyr).xmin_gap
      xmax_gap = ftrk_par(dev).lyr(lyr).xmax_gap
      ymin_gap = ftrk_par(dev).lyr(lyr).ymin_gap
      ymax_gap = ftrk_par(dev).lyr(lyr).ymax_gap

c     Compute the intersection point in the local coordinates of
c     the chamber.
      if ( type .eq. 2 .or. type .eq. 3 ) then
         xl =  w.x*ftrk_par(dev).lyr(lyr).cos_stereo +
     +         w.y*ftrk_par(dev).lyr(lyr).sin_stereo

         yl = -w.x*ftrk_par(dev).lyr(lyr).sin_stereo +
     +         w.y*ftrk_par(dev).lyr(lyr).cos_stereo
      else
         xl = w.x
         yl = w.y
      endif


      lstrike = ( xl.ge.xmin .and. xl.le.xmax) .and. 
     *          ( yl.ge.ymin .and. yl.le.ymax) .and. 
     *          ((xl.ge.xmax_gap .or. xl.le.xmin_gap) .or.
     *           (yl.ge.ymax_gap .or. yl.le.ymin_gap) )

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
c Revision 1.4  2000/01/26 00:44:42  kutschke
c Implement types 2 and 3.
c
c Revision 1.3  1999/03/24  02:12:48  mcbride
c fix comments
c
c Revision 1.2  1997/04/04  20:30:22  garren
c add rcs log line
c
