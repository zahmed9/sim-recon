      integer function move_wtk_arcpath_bz(w1, slen, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in a solenoidal B field.
c
c  w1       w track structure (read)
c           Initial track parameters
c
c  slen     Arc structure (read)
c           Arc length information
c
c  bf       B field structure (read)
c           B field information
c
c *w2       w track structure (write)
c           Track parameters after move
c
c return    
c           0 ==> all OK
c           1 ==> track cannot be projected
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
c   The equations of motion are
c
c     Px = Px0*cos(rho*s) - Py0*sin(rho*s)
c     Py = Py0*cos(rho*s) + Px0*sin(rho*s)
c     Pz = Pz0
c      E = E0
c      x = x0 + {Px0*sin(rho*s) - Py0*[1-cos(rho*s)]} / a = x0 + (Py-Py0)/a
c      y = y0 + {Py0*sin(rho*s) + Px0*[1-cos(rho*s)]} / a = y0 - (Px-Px0)/a
c      z = z0 + (Pz0/Pt)*s
c
c   where s = arc length in r-phi plane
c         a = c_b * Bfield * q (c_b is defined in const.inc)
c       rho = a / Pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "arc_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      record /arc_struct/ slen

c     local variables
      DFLOAT rho, s, ps, sinps, cosps, dcosps
      DFLOAT a, ainv, px, py
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     quit if no pt
      if(w1.pt .eq. 0.) goto 9999
    
      a = c_b * bf.bmag * bf.bdir(3) * w1.q
      rho = a / w1.pt

      s = slen.s
      sinps = slen.sinps
      cosps = slen.cosps
      dcosps = 1. - cosps

      ainv = 1. / a

      px = w1.px*cosps - w1.py*sinps
      py = w1.py*cosps + w1.px*sinps
      w2.px = px
      w2.py = py
      w2.pz = w1.pz
      w2.E = w1.E
      w2.x = w1.x + (px*sinps - py*dcosps) * ainv
      w2.y = w1.y + (py*sinps + px*dcosps) * ainv
      w2.z = w1.z + (w1.pz/w1.pt) * s
      w2.pt = w1.pt
      w2.p = w1.p
      w2.q = w1.q

c     normal return
      move_wtk_arcpath_bz = 0
      return

c     error return
9999  move_wtk_arcpath_bz = 1
      call ucopy(w1, w2, WTRACK_WORD)

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:43  garren
c add rcs log line
c
