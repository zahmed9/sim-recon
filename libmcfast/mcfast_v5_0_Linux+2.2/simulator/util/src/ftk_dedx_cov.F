      function ftk_dedx_cov ( f, fcov, mass, dedx, eta, direction )

c
c     Rob Kutschke, Oct 28, 1998
c
c     Apply dedx to an ftrack and its covariance matrix.
c
c     Unlike a lot of other routines, these routines do not make a
c     separate copy of their output, they update their input.
c
c     The change to the covariance matrix is usually very small and has
c     not yet been implemented.
c

#include "const.inc"
#include "ftrack_struct.inc"

      integer ftk_dedx_cov

c     Input and output: Track parameters and their covariance matrix.
      record /ftrack_struct/ f
      DFLOAT fcov(FTRACK_NPAR,FTRACK_NPAR)

c     Input: Mass of the particle
      DFLOAT mass

c     Input: energy loss at normal incidence for minimum ionizing particle.
      DFLOAT dedx

c     Input: Direction cosines of the normal to the surface.
      DFLOAT eta(3)

c     Input: Sign to control energy addition or subtraction.
c            +1. = energy loss
c            -1. = energy gain
      DFLOAT direction

c     Function called.
      DFLOAT dedx_loss

c     Stuff.
      DFLOAT dot, ratio, pnew

      dot = abs( f.xslp * eta(1) + f.yslp * eta(2) + eta(3) ) /
     +       sqrt( 1. + f.xslp**2 + f.yslp**2 )
      if(dot .eq. 0.) dot = 1.E-6

      pnew = dedx_loss ( f.p, mass, direction*dedx/dot )
      if ( pnew .eq. 0. ) goto 999
      ratio    = f.p / pnew
      f.alpha  = f.alpha * ratio
      f.pt     = f.pt    / ratio
      f.p      = pnew

c     We are still missing a step.  The covariance matrix needs to
c     be updated for the change in energy.

c     Normal return.
      ftk_dedx_cov = 0
      return

c     Error return.
 999  ftk_dedx_cov = 1
      end
