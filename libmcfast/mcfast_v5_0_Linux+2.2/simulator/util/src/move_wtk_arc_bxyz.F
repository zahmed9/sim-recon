      integer function move_wtk_arc_bxyz(w1, s3d, bf, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Takes a helix expressed in w form and calculates the new parameters
c  a distance along the trajectory in an arbitrarily oriented, constant
c  B field.
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
c     p_v = p0_v*cos(rho*s) - (p0_v x h_v) * sin(rho*s)
c                           + [p0_v,h_v]/p * h_v * {1-cos(rho*s)}
c
c     x_v = x0_v + p0_v/a*sin(rho*s) - (p0_v x h_v)/a * {1 - cos(rho*s)}
c                + [p0_v,h_v]/p * h_v * {s - sin(rho*s)/rho}
c
c   where s = arc length
c         a = c_b * Bfield * q (c_b is defined in const.inc)
c       rho = a / p
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
      DFLOAT ps, sinps, cosps, dcosps, rho
      DFLOAT a, px, py, pz, ph(3), pdoth
      DFLOAT t1, t2, t3
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      a = c_b * bf.bmag * w1.q
      rho = a / w1.p
      ps = rho * s3d

      sinps = sin(ps)
      cosps = cos(ps)
      dcosps = 1. - cosps

      ph(1) = w1.py*bf.bdir(3) - w1.pz*bf.bdir(2)
      ph(2) = w1.pz*bf.bdir(1) - w1.px*bf.bdir(3)
      ph(3) = w1.px*bf.bdir(2) - w1.py*bf.bdir(1)

      pdoth = w1.px*bf.bdir(1) + w1.py*bf.bdir(2) + w1.pz*bf.bdir(3)

c     Move position & momentum. Check if no bend.
      if(rho .ne. 0.) then
        t1 = sinps / a
        t2 = dcosps / a
        t3 = pdoth * (s3d - sinps/rho) / w1.p
        w2.x = w1.x + w1.px*t1 - ph(1)*t2 + bf.bdir(1)*t3
        w2.y = w1.y + w1.py*t1 - ph(2)*t2 + bf.bdir(2)*t3
        w2.z = w1.z + w1.pz*t1 - ph(3)*t2 + bf.bdir(3)*t3

        t3 = pdoth * dcosps
        px = w1.px*cosps - ph(1)*sinps + bf.bdir(1)*t3
        py = w1.py*cosps - ph(2)*sinps + bf.bdir(2)*t3
        pz = w1.pz*cosps - ph(3)*sinps + bf.bdir(3)*t3

        w2.px = px
        w2.py = py
        w2.pz = pz

      else
        t1 = s3d / w1.p
        w2.x = w1.x + w1.px*t1
        w2.y = w1.y + w1.py*t1
        w2.z = w1.z + w1.pz*t1
        w2.px = w1.px
        w2.py = w1.py
        w2.pz = w1.pz
      endif

      
      w2.E = w1.E
      w2.pt = sqrt(px**2 + py**2)
      w2.p = w1.p
      w2.q = w1.q

c     Normal return
      move_wtk_arc_bxyz = 0
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:45  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:41  garren
c add rcs log line
c
