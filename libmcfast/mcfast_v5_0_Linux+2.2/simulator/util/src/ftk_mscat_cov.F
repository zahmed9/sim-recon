      subroutine ftk_mscat_cov(f, fcov1, mass, radl, eta, fcov2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the effects of multiple scattering to a f track covariance matrix.
c
c            sig_theta = c_ms * sqrt(rad_length) / (p*beta)
c
c  The multiple scattering covariance matrix for (alpha,xslp,yslp,x,y), 
c  assuming infinitely thin materials, is calculated from the derivative 
c  matrix:
c
c          |(1/sinth)*dalpha/dphi     dalpha/dtheta  |
c      D = |(1/sinth)*dxslp/dphi      dxslp/dtheta   |
c          |(1/sinth)*dyslp/dphi      dyslp/dtheta   |
c          |(1/sinth)*dx/dphi         dx/dtheta      |
c          |(1/sinth)*dy/dphi         dy/dtheta      |
c
c
c
c
c      Vms = (c_ms/p*beta)^2 * rad_length * (D * Dt)
c
c  ..........................................................................
c
c  Inputs:
c  f          f track structure
c             Track parameters before scatter
c
c  fcov1      DFLOAT array
c             Initial 5x5 covariance matrix of f
c
c  mass       DFLOAT variable
c             mass of the particle.
c
c  radl       DFLOAT variable
c             # of radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Outputs:
c  fcov2      DFLOAT array
c             Updated  5x5 covariance matrix of f
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "const.inc"
#include "ftrack_struct.inc"

c     Calling arguments
      record /ftrack_struct/ f
      DFLOAT fcov1(5,5), mass, radl, eta(3), fcov2(5,5)

c     Local variables
      integer i, j
      DFLOAT vms(3,3), sigsq, dot, psq, ptsq, cossq, sinsq
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call ucopy(fcov1, fcov2, 5*5*FLOAT_WORD)

      if(f.p.eq.0. .or. f.alpha.eq.0.) goto 9999

      psq = f.p**2
      ptsq = f.pt**2
      cossq = 1.0 / (f.alpha**2 * psq)
      if(cossq .eq. 0.) cossq = 1.e-6
      sinsq = ptsq / psq

c     Calculate mean angle^2 from multiple scattering for each direction
c     If track is along surface, make scatter huge
      dot = abs(eta(1)*f.xslp/f.alpha + eta(2)*f.yslp/f.alpha + eta(3)/
     *                                       f.alpha) / f.p
      if(dot .eq. 0.) dot = 1.0E-6

      sigsq = (c_ms * sqrt( psq+mass**2) / psq)**2 * (radl / dot)

      vms(1,1) = f.alpha**2 * (f.xslp**2 + f.yslp**2)
      vms(1,2) = f.xslp * f.alpha / cossq
      vms(1,3) = f.yslp * f.alpha / cossq
      vms(2,2) = f.yslp**2 /sinsq + f.xslp**2 /cossq / sinsq
      vms(2,3) = f.xslp*f.yslp / cossq
      vms(3,3) = f.xslp**2 / sinsq + f.yslp**2 / sinsq / cossq
      vms(2,1) = vms(1,2)
      vms(3,1) = vms(1,3)
      vms(3,2) = vms(2,3)

      do i=1,3
        do j=1,3
          fcov2(j,i) = fcov1(j,i) + sigsq * vms(j,i)
        enddo
      enddo

      return

c     Error return
9999  return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.4  1998/02/13 23:08:38  kutschke
c p/p**2 should be E/p**2.
c
c Revision 1.3  1997/04/04  20:31:33  garren
c add rcs log line
c
