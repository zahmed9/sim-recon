      subroutine wtk_photon_brem(win, wout, wbrem)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Create photon w track from momentum difference between incoming and
c  outgoing tracks. The photon total momentum is the difference of
c  momenta and the direction is the direction of the original track.
c  .........................................................................
c
c  Inputs:
c
c  win        w track structure
c             Track parameters of incoming electron
c
c  wout       w track structure
c             Track parameters of outgoing electron
c
c  Outputs:
c  wbrem      w track structure
c             Track parameters of emitted photon
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Externals

c     Calling arguments
      record /wtrack_struct/ win, wout, wbrem

c     Local variables
      DFLOAT p, ratio
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      p = win.p - wout.p
      ratio = p / win.p

      wbrem.px = win.px * ratio
      wbrem.py = win.py * ratio
      wbrem.pz = win.pz * ratio
      wbrem.E = sqrt(wbrem.px**2 + wbrem.py**2 + wbrem.pz**2)
      wbrem.x = win.x
      wbrem.y = win.y
      wbrem.z = win.z
      wbrem.pt = sqrt(wbrem.px**2 + wbrem.py**2)
      wbrem.p = wbrem.E
      wbrem.q = 0.
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:04  garren
c add rcs log line
c
