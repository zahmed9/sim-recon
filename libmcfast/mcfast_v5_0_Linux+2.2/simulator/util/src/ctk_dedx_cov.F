      integer function ctk_dedx_cov (c, ccov, mass, dedx, eta, direct )
c
c Apply energy loss correction to the track and to the covariance matrix.
c
c Unlike many other routines, this routine updates its arguments rather
c than copying input to output.
c
c Input/Output:
c c       - ctrack structure
c         - track parameters
c
c ccov    - DFLOAT array
c         - covariance matrix
c
c Input Only:
c mass    - DFLOAT
c         - mass of the particle in GeV.
c
c dedx    - DFLOAT
c         - Thickness of the material in units of the radiation length of
c           the material.
c
c eta     - DFLOAT array
c         - unit normal to the surface
c
c direct  - integer
c         - direction control
c            +1 = fit is going outward.  Energy is lost in this step.
c            -1 = fit is going inward.  Energy is gained in this step.
c
c Notes:
c 1) The model of energy loss is that the energy of the particle
c    changes by the specified amount but that the direction remains
c    constant.  See CLEO CBX 96-20 for details of how this implies
c    a change in the covariance matrix from a purely geometric effect.
c    See page 20 of the CLEO note.  This is very important at very low
c    momentum.
c 2) Since MCFast does not incorporate a model of straggling in
c    energy loss, this section of the code remains commented out.
c

#include "const.inc"
#include "ctrack_struct.inc"

c     Externals
      external dedx_loss
      DFLOAT   dedx_loss

c     Number of track parameters = dimension of covariance matrix.
      integer MPAR
      parameter ( MPAR = 5 ) 

c     Calling arguments.
      record /ctrack_struct/ c
      DFLOAT ccov(MPAR,MPAR)
      DFLOAT mass
      DFLOAT dedx
      DFLOAT eta(3)
      integer direct

c     Local variables.

c     Sine and cosine of the polar angle of the track wrt the beam line.
      DFLOAT sinth, costh

c     Cosine of angle between track and surface.
      DFLOAT dot

c     Updated momentum.
      DFLOAT pnew

c     Curvature, momentum and energy on input.
      DFLOAT cu_old, p_old, e_old

c     Energy on output.
      DFLOAT e

c     Coefficients from page 22 of CLEO CBX 96-20 Kalman note.
      DFLOAT a, b

c     The amount of straggling in energy loss, in GeV.
      DFLOAT dde

c     Stuff.
      DFLOAT ratio
      DFLOAT arg

      cu_old = c.cu
      e_old  = sqrt(c.p**2 + mass**2 )
      p_old  = c.p

      sinth = 1./sqrt( 1. + c.ct**2 )
      costh = c.ct*sinth

      dot = abs(( sinth*cos(c.phi0) * eta(1) +
     *            sinth*sin(c.phi0) * eta(2) +
     *            costh             * eta(3) ))
      if(dot .eq. 0.) dot = 1.E-6

      arg  = dfloat(direct)*dedx/dot
      pnew = dedx_loss(c.p, mass, arg )

      if ( pnew .le. 0 ) goto 9999

      ratio = c.p / pnew
      c.cu  = c.cu * ratio
      c.pt  = c.pt / ratio
      c.p   = pnew

c     Update the covariance matrix for the geometric effect of the
c     change of energy.
      e = sqrt(c.p**2 + mass**2 )
      a = (c.cu/cu_old)**3*e/e_old
      b = c.ct/(1.+c.ct**2)*c.cu*(1.-(c.cu/cu_old)**2*(e/e_old))

      ccov(jccu,jccu)  = a*a*ccov(jccu,jccu) + 2*a*b*ccov(jccu,jcct) +
     +                   b*b*ccov(jcct,jcct)

      ccov(jccu,jcphi) = a*ccov(jccu,jcphi) + b*ccov(jcct,jcphi)
      ccov(jccu,jcda)  = a*ccov(jccu,jcda ) + b*ccov(jcct,jcda )
      ccov(jccu,jcct)  = a*ccov(jccu,jcct ) + b*ccov(jcct,jcct )
      ccov(jccu,jcz0)  = a*ccov(jccu,jcz0 ) + b*ccov(jcct,jcz0 )

      ccov(jcphi,jccu) = ccov(jccu,jcphi)
      ccov(jcda, jccu) = ccov(jccu,jcda )
      ccov(jcct, jccu) = ccov(jccu,jcct )
      ccov(jcz0, jccu) = ccov(jccu,jcz0 )

c     Correction to covariance matrix for straggling in energy loss.
c     dde = 0.
c     ccov(jccu,jccu) = ccov(jccu,jccu) + 
c    +                  ( dde * e_old * cu_old/ p_old**2 )**2

c     Normal return.
      ctk_dedx_cov = 0
      return

c     Error return.
 9999 ctk_dedx_cov = 1

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.1  1999/05/12 20:21:37  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c
