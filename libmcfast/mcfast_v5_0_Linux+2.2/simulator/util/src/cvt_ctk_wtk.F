      integer function cvt_ctk_wtk(c, mass, w)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a track expressed in helix form and converts it into kinematic
c  form at the point of closest approach to the reference point.
c
c  c        c track structure (read)
c           Helix track parameters
c
c  mass     DFLOAT variable (read)
c           mass of particle (used in energy calculation)
c
c *w        w track structure (write)
c           Kinematic track parameters
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be computed
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "ctrack_struct.inc"

c     calling arguments
      record /wtrack_struct/ w
      record /ctrack_struct/ c
      DFLOAT mass

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(c.pt .eq. 0.) goto 9999

      w.px = c.pt * c.u0
      w.py = c.pt * c.v0
      w.pz = c.pt * c.ct
      w.E = sqrt(c.p**2 + mass**2)
      w.x = -c.da * c.v0 + c.xref
      w.y =  c.da * c.u0 + c.yref
      w.z = c.z0 + c.zref
      w.pt = c.pt
      w.p = c.p
      w.q = c.q

      cvt_ctk_wtk = 0
      return

c     error return
9999  cvt_ctk_wtk = 1
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
