      integer function cvt_ftk_wtk(f, mass, w)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in forward form and converts it into
c  kinematic form at the same point..
c
c  f        Forward track structure (read)
c           f track parameters (alpha, x'_p, y'_p, x_p, y_p, z_p, pt, p, q)
c
c  mass     DFLOAT variable (read)
c           mass of particle (used in energy calculation)
c
c *w        Kinematic track structure (write)
c           w track parameters (px, py, pz, e, x, y, z, pt, p, q)
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "ftrack_struct.inc"

c     calling arguments
      DFLOAT mass
      record /wtrack_struct/ w
      record /ftrack_struct/ f

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(f.alpha .eq. 0. .or. f.p .eq. 0.) goto 9999

      w.px = f.xslp / f.alpha
      w.py = f.yslp / f.alpha
      w.pz = 1. / f.alpha
      w.E = sqrt(f.p**2 + mass**2)
      w.x = f.xp
      w.y = f.yp
      w.z = f.zp
      w.pt = f.pt
      w.p = f.p
      w.q = f.q
      cvt_ftk_wtk = 0
      return

c     error return
9999  cvt_ftk_wtk = 1
      call vzero(w, WTRACK_WORD)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:59  garren
c add rcs log line
c
