      integer function move_wtk_arc_bx(w1, s3d, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in a dipole B field along the x axis.
c
c  w1       w track structure (read)
c           Initial track parameters
c
c  s3d      DFLOAT variable (read)
c           Arc length to project track
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
c     Px = Px0
c     Py = Py0*cos(rho*s) - Pz0*sin(rho*s)
c     Pz = Pz0*cos(rho*s) + Py0*sin(rho*s)
c      E = E0
c      x = x0 + (Px0/Pt)*s
c      y = y0 + {Py0*sin(rho*s) - Pz0*[1-cos(rho*s)]} / a = y0 + (Pz-Pz0)/a
c      z = z0 + {Pz0*sin(rho*s) + Py0*[1-cos(rho*s)]} / a = z0 - (Py-Py0)/a
c
c   where s = arc length in r-phi plane
c         a = c_b * Bfield * q (c_b is defined in const.inc)
c       rho = a / Pt
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "bfield_struct.inc"
#include "const.inc"

c     calling arguments
      record /wtrack_struct/ w1, w2
      record /bfield_struct/ bf
      DFLOAT s3d

c     local variables
      DFLOAT ps, sinps, cosps, dcosps
      DFLOAT a, ainv, py, pz
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * bf.bdir(1) * w1.q
      ps = a / w1.p * s3d

      sinps = sin(ps)
      cosps = cos(ps)
      dcosps = 1. - cosps

      ainv = 1. / a

      w2.x = w1.x + (w1.px/w1.p) * s3d
      w2.y = w1.y + (w1.py*sinps - w1.pz*dcosps) * ainv
      w2.z = w1.z + (w1.pz*sinps + w1.py*dcosps) * ainv
      py = w1.py*cosps - w1.pz*sinps
      pz = w1.pz*cosps + w1.py*sinps
      w2.px = w1.px
      w2.py = py
      w2.pz = pz
      w2.E = w1.E
      w2.pt = sqrt(w2.px**2 + w2.py**2)
      w2.p = w1.p
      w2.q = w1.q

c     normal return
      move_wtk_arc_bx = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:41  garren
c add rcs log line
c
