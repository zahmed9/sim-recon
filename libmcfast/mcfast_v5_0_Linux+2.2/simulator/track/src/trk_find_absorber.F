      subroutine trk_find_absorber(w, dev, lstrike)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c   Find where a track went through absorber
c
c  Inputs:
c
c  w          w track structure
c             Track parameters
c
c  dev        integer variable
c             absorber number
c
c  Outputs:
c
c  lstrike    logical variable
c             TRUE if track falls within plane boundaries
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "absorber.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      integer dev
      logical lstrike
      record /wtrack_struct/ w

c     Local variables
      real xmin,xmax,ymin,ymax,xmin_gap,xmax_gap,ymin_gap,ymax_gap

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      lstrike = .false.
      
      if (dev .le. 0) return

      xmin = absorber_par(dev).xlimit(1)
      xmax = absorber_par(dev).xlimit(2)
      ymin = absorber_par(dev).ylimit(1)
      ymax = absorber_par(dev).ylimit(2)
      xmin_gap = absorber_par(dev).xlimit_gap(1)
      xmax_gap = absorber_par(dev).xlimit_gap(2)
      ymin_gap = absorber_par(dev).ylimit_gap(1)
      ymax_gap = absorber_par(dev).ylimit_gap(2)

      lstrike = (w.x.ge.xmin .and. w.x.le.xmax) .and. 
     *          (w.y.ge.ymin .and. w.y.le.ymax) .and. 
     *          ((w.x.ge.xmax_gap .or. w.x.le.xmin_gap) .or.
     *          (w.y.ge.ymax_gap .or. w.y.le.ymin_gap))
      
      return
      
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:35  eugenio
c Initial revision
c
c Revision 1.1  1999/03/24 02:10:43  mcbride
c add routine to find gaps in scattering surfaces
c
