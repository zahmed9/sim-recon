      integer function ctk_mscat_cov(c, ccov1, mass, radl, eta, ccov2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the effects of multiple scattering to a c track covariance matrix.
c
c            sig_theta = c_ms * sqrt(rad_length) / (p*beta)
c
c  The multiple scattering covariance matrix for (c,phi0,D,ct,z0),
c  assuming infinitely thin materials, is calculated from the derivative
c  matrix:
c
c          |(1/sinth)*dcu/dphi     dcu/dtheta  |
c          |(1/sinth)*dfi/dphi     dfi/dtheta  |
c      D = |(1/sinth)*dda/dphi     dda/dtheta  |
c          |(1/sinth)*dct/dphi     dct/dtheta  |
c          |(1/sinth)*dz0/dphi     dz0/dtheta  |
c
c
c      Vms = (c_ms/p*beta)^2 * rad_length * (D * Dt)
c
c  It can easily be shown that, when the scattering point is at the
c  reference point (see Fitting Theory V, P. 10-11 CBX 92-39)
c
c          | 0         -cu*ct    |
c          |p/pt          0      |
c      D = | 0            0      |
c          | 0        -(p/pt)**2 |
c          | 0            0      |
c
c
c               |  (cu*ct)**2        0          0     cu*ct*(p/pt)**2  0  |
c               |      0         (p/pt)**2      0        0             0  |
c   so D * Dt = |      0             0          0        0             0  |
c               |  cu*ct*(p/pt)**2   0          0     (p/pt)**4        0  |
c               |      0             0          0        0             0  |
c  ..........................................................................
c
c  Inputs:
c  c          c track structure
c             Track parameters before scatter
c
c  ccov1      DFLOAT array
c             Initial 7x7 covariance matrix of c
c
c  mass       DFLOAT variable
c             mass of particle
c
c  radl       DFLOAT variable
c             # of radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Outputs:
c  ccov2      DFLOAT array
c             Updated  5x5 covariance matrix of c
c
c  Return value:
c             0     = OK
c             other = error
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "const.inc"
#include "ctrack_struct.inc"

c     Calling arguments
      record /ctrack_struct/ c
      DFLOAT ccov1(5,5), mass, radl, eta(3), ccov2(5,5)

c     Local variables
      DFLOAT sigsq, dot, psq, Esq, ratio
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call ucopy(ccov1, ccov2, 5*5*FLOAT_WORD)

      psq = c.p**2
      Esq = psq + mass**2

      if(c.pt .gt. 0.) then
        ratio = c.p / c.pt
      else
        ratio = 1.e8
      endif

c     Calculate mean angle^2 from multiple scattering for each direction
c     If track is along surface, make scatter huge
      dot = abs(eta(1)*c.u0 + eta(2)*c.v0 + eta(3)*c.ct) / ratio
      if(dot .eq. 0.) dot = 1.E-6

      sigsq = (c_ms / psq)**2 * Esq * (radl / dot)

      ccov2(1,1) = ccov2(1,1) + sigsq*(c.cu*c.ct)**2
      ccov2(2,2) = ccov2(2,2) + sigsq*ratio**2
      ccov2(4,4) = ccov2(4,4) + sigsq*ratio**4
      ccov2(1,4) = ccov2(1,4) + sigsq*(c.cu*c.ct*ratio**2)
      ccov2(4,1) = ccov2(1,4)

c     Normal return.
      ctk_mscat_cov = 0

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.5  1999/05/12 20:21:38  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c Revision 1.4  1998/03/17  22:20:43  kutschke
c Bugfix: Add (1,4) and (4,1) terms.
c
c Revision 1.3  1997/04/04  20:30:58  garren
c add rcs log line
c
