      integer function cvt_wtk_ftk(w, f)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in kinematic form and converts it into
c  forward form.
c
c  w        Kinematic track structure (read)
c           w track parameters
c
c *f        Forward track structure (read)
c           f track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "ftrack_struct.inc"

c     calling arguments
      record /wtrack_struct/ w
      record /ftrack_struct/ f

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(w.pz .eq. 0.) goto 9999

      f.alpha = 1. / w.pz
      f.xslp = w.px * f.alpha
      f.yslp = w.py * f.alpha
      f.xp = w.x
      f.yp = w.y
      f.zp = w.z
      f.pt = w.pt
      f.p = w.p
      f.q = w.q

      cvt_wtk_ftk = 0
      return

c     error return
9999  cvt_wtk_ftk = 1
      call vzero(f, FTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:00  garren
c add rcs log line
c
