      subroutine geo_ftrk_xy_limits ( d, l, xmi, xma, ymi, yma )

#include "const.inc"
#include "for_trk.inc"

c     Arguments:
c     Input: Device and layer number with for_trk.inc.
      integer d, l

c     Output: Min/max values of x and y.
      real xmi, xma, ymi, yma

c     World coordinates of rotated points.
      real x1, y1

c     Dummy arguments to statement functions.
      integer j
      real x, y

c     Statement functions.
      xrot(x,y) = x*ftrk_par(d).lyr(l).cos_stereo - 
     +            y*ftrk_par(d).lyr(l).sin_stereo
      yrot(x,y) = x*ftrk_par(d).lyr(l).sin_stereo + 
     +            y*ftrk_par(d).lyr(l).cos_stereo

c     Do the easy cases.
      if ( ftrk_par(d).lyr(l).type .ne. 2 .and. 
     +     ftrk_par(d).lyr(l).type .ne. 3      ) then
         xmi = ftrk_par(d).xmin
         xma = ftrk_par(d).xmax
         ymi = ftrk_par(d).ymin
         yma = ftrk_par(d).ymax
         return
      endif

c     Check the lower left corner.
      x1  = xrot( ftrk_par(d).lyr(l).xmin, ftrk_par(d).lyr(l).ymin )
      y1  = yrot( ftrk_par(d).lyr(l).xmin, ftrk_par(d).lyr(l).ymin )
      xmi = x1
      xma = x1
      ymi = y1
      yma = y1

c     Check the upper left corner.
      x1  = xrot( ftrk_par(d).lyr(l).xmin, ftrk_par(d).lyr(l).ymax )
      y1  = yrot( ftrk_par(d).lyr(l).xmin, ftrk_par(d).lyr(l).ymax )
      xmi = min( xmi, x1 )
      xma = max( xma, x1 )
      ymi = min( ymi, y1 )
      yma = max( yma, y1 )

c     Check the upper right corner.
      x1  = xrot( ftrk_par(d).lyr(l).xmax, ftrk_par(d).lyr(l).ymax )
      y1  = yrot( ftrk_par(d).lyr(l).xmax, ftrk_par(d).lyr(l).ymax )
      xmi = min( xmi, x1 )
      xma = max( xma, x1 )
      ymi = min( ymi, y1 )
      yma = max( yma, y1 )

c     Check the lower left corner.
      x1  = xrot( ftrk_par(d).lyr(l).xmax, ftrk_par(d).lyr(l).ymin )
      y1  = yrot( ftrk_par(d).lyr(l).xmax, ftrk_par(d).lyr(l).ymin )
      xmi = min( xmi, x1 )
      xma = max( xma, x1 )
      ymi = min( ymi, y1 )
      yma = max( yma, y1 )

      end
