      subroutine wtk_mscat(w1, radl, eta, w2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add multiple scattering to a w track.
c
c            sig_theta = c_ms * sqrt(rad_length) / (p*beta)
c
c  Here we approximate the change in angle by adding momentum in directions
c  orthogonal to the orginal direction of motion. The momentum is then
c  normalized so that the total momentum is unchanged.
c
c  The vector equation expressing the change is
c
c    p = p0 + (p ^ z)/|p ^ z| * dp1 + (p ^ z ^ p)/|p ^ z ^ p| * dp2
c
c  where dp1 and dp2 are the (randomly chosen) momentum components due
c  to multiple scattering and z is a unit vector along the z axis.
c
c  Note that
c
c      p ^ z ^ p = z*(p**2) - p*(pz)
c
c      |p ^ z|     = pt   = sqrt[p**2 - p_z**2]
c      |p ^ z ^ p| = pt*p = sqrt[p**2 - p_z**2] * p
c            
c  After the scatter, the momentum components are rescaled according to
c
c      p_x' = p_x * (p0/p)
c      p_y' = p_y * (p0/p)
c      p_z' = p_z * (p0/p)
c  ..........................................................................
c
c  Inputs:
c  w1         w track structure
c             Track parameters before scatter
c
c  radl       DFLOAT variable
c             # of radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Outputs:
c  w2         w track structure
c             Track parameters after scatter
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Externals
      external get_gauss
      real     get_gauss

c     Calling arguments
      record /wtrack_struct/ w1, w2
      DFLOAT radl, eta(3)

c     Local variables
      DFLOAT dp1, dp2, p, pt, pinv, pvec(3), pnew
      DFLOAT sig_pt, eta1(3), eta2(3), dot
      DFLOAT ptinv, ratio, temp
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      p = w1.p
      pt = w1.pt
      pinv = 1. / p
      ptinv = 1. / w1.pt

c     Calculate mean pt from multiple scattering for each direction
c     If track is along surface, make scatter huge
      dot = (eta(1)*w1.px + eta(2)*w1.py + eta(3)*w1.pz) / w1.p
      if(dot .eq. 0.) dot = 1.E-6
      sig_pt = c_ms * (w1.E * pinv) * sqrt(abs(radl/dot))

      dp1 =  sig_pt * get_gauss(0)
      dp2 =  sig_pt * get_gauss(0)

c     If p is too close to z axis, be careful
      if(w1.pt .gt. 0.001*p) then
        temp = w1.pz * pinv * ptinv
        eta1(1) =  w1.py * ptinv
        eta1(2) = -w1.px * ptinv
        eta1(3) = 0.
        eta2(1) = -w1.px * temp
        eta2(2) = -w1.py * temp
        eta2(3) =  w1.pt * pinv
        pvec(1) = w1.px + dp1*eta1(1) + dp2*eta2(1)
        pvec(2) = w1.py + dp1*eta1(2) + dp2*eta2(2)
        pvec(3) = w1.pz               + dp2*eta2(3)
      else
        pvec(1) = w1.px + dp1
        pvec(2) = w1.py + dp2
        pvec(3) = w1.pz
      endif

c     Normalize the momentum
      pnew = sqrt(pvec(1)**2 + pvec(2)**2 + pvec(3)**2)

c     Normal exit
      ratio = p / pnew
      w2.px = pvec(1) * ratio
      w2.py = pvec(2) * ratio
      w2.pz = pvec(3) * ratio
      w2.E  = w1.E
      w2.x  = w1.x
      w2.y  = w1.y
      w2.z  = w1.z
      w2.pt = sqrt( w2.px**2 + w2.py**2 )
      w2.p  = w1.p
      w2.q  = w1.q

      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.4  1998/01/27 21:13:59  kutschke
c Compute w2.pt - do not copy from w1
c
c Revision 1.3  1997/04/04  20:32:02  garren
c add rcs log line
c
