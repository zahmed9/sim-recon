      subroutine wtk_mscat_cov(w, wcov1, radl, eta, wcov2)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Add the effects of multiple scattering to a w track covariance matrix.
c
c            sig_theta = c_ms * sqrt(rad_length) / (p*beta)
c
c  The multiple scattering covariance matrix for (px,py,pz), assuming
c  infinitely thin materials, is calculated from the derivative matrix:
c
c          |(1/sinth)*dpx/dphi     dpx/dtheta  |
c      D = |(1/sinth)*dpy/dphi     dpy/dtheta  |
c          |(1/sinth)*dpz/dphi     dpz/dtheta  |
c
c
c      Vms = (c_ms/p*beta)^2 * rad_length * (D * Dt)
c
c  It can easily be shown that (D*Dt)[ij] = P^2*I[ij] - Pi*Pj, or
c
c             |p^2-px^2    -py*px        -pz*px      |
c      D*Dt = |-px*py      p^2 - py^2    -pz*py      |
c             |-px*pz      -py*pz        p^2 - pz^2  |
c  ..........................................................................
c
c  Inputs:
c  w          w track structure
c             Track parameters before scatter
c
c  wcov1      DFLOAT array
c             Initial 7x7 covariance matrix of w
c
c  radl       DFLOAT variable
c             # of radiation lengths
c
c  eta(3)     DFLOAT array
c             Direction cosines of surface of scatterer. Need this to
c             calculate effective path length through material.
c
c  Outputs:
c  wcov2      DFLOAT array
c             Updated  7x7 covariance matrix of w
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#include "const.inc"
#include "wtrack_struct.inc"

c     Calling arguments
      record /wtrack_struct/ w
      DFLOAT wcov1(7,7), radl, eta(3), wcov2(7,7)

c     Local variables
      integer i, j
      DFLOAT vms(3,3), sigsq, dot, psq
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      call ucopy(wcov1, wcov2, 7*7*FLOAT_WORD)

      if(w.p .eq. 0.) goto 9999

      psq = w.p**2

c     Calculate mean angle^2 from multiple scattering for each direction
c     If track is along surface, make scatter huge
      dot = abs(eta(1)*w.px + eta(2)*w.py + eta(3)*w.pz) / w.p
      if(dot .eq. 0.) dot = 1.E-6

      sigsq = (c_ms * w.E / psq)**2 * (radl / dot)

      vms(1,1) = (psq - w.px**2) * sigsq
      vms(1,2) = -w.px*w.py * sigsq
      vms(1,3) = -w.px*w.pz * sigsq
      vms(2,2) = (psq - w.py**2) * sigsq
      vms(2,3) = -w.py*w.pz * sigsq
      vms(3,3) = (psq - w.pz**2) * sigsq
      vms(2,1) = vms(1,2)
      vms(3,1) = vms(1,3)
      vms(3,2) = vms(2,3)

      do i=1,3
        do j=1,3
          wcov2(j,i) = wcov1(j,i) + vms(j,i)
        enddo
      enddo

      return

c     Error return
9999  return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:03  garren
c add rcs log line
c
