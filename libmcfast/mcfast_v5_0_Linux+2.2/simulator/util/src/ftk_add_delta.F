      integer function ftk_add_delta ( f_in, delta_f, f_out )

c
c     A Kalman filter service routine.
c     Add the correction term, delta_f, to f_in.
c     Only for the ftk parameterization.
c
c     This routine is used in the updating step of the Kalman filter so it
c     is possible that sometimes f_out.alpha may be zero.  This is perfectly
c     well defined, unless one wants to calculate the momentum!  In this
c     case the momentum is set to some "safely large" value.
c

      implicit none

#include "ftrack_struct.inc"
#include "const.inc"

      ! Number of track parameters.
      integer NPAR
      parameter ( NPAR = 5 )

c Input arguments.

      ! Input track parameters.
      record /ftrack_struct/ f_in

      ! Input correction to track parameters.
      DFLOAT delta_f(NPAR)

c Output arguments.

      ! Output track parameters.
      record /ftrack_struct/ f_out

c Local variable.s

      ! Temporyary so that f_in and f_out may share storage.
      record /ftrack_struct/ f_tmp

      ! Should make this a function of Ecm or call an access function
      ! to get it.
      DFLOAT pmax
      parameter ( pmax = 1000. )

      ! Functions.
      DFLOAT phi_norm


c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      f_tmp.alpha = f_in.alpha + delta_f(1)
      f_tmp.xslp  = f_in.xslp  + delta_f(2)
      f_tmp.yslp  = f_in.yslp  + delta_f(3)
      f_tmp.xp    = f_in.xp    + delta_f(4)
      f_tmp.yp    = f_in.yp    + delta_f(5)
      f_tmp.zp    = f_in.zp
      f_tmp.q     = f_in.q

      if ( f_tmp.alpha .ne. 0. ) then
         f_tmp.p    = sqrt( 1. + f_tmp.xslp**2 + f_tmp.yslp**2 ) / 
     +                abs(f_tmp.alpha)
         f_tmp.pt   = sqrt( f_tmp.xslp**2 + f_tmp.yslp**2 ) / 
     +                abs(f_tmp.alpha)
      else
         f_tmp.p    = pmax
         f_tmp.pt   = f_tmp.p * sqrt( 
     +                (f_tmp.xslp**2 + f_tmp.yslp**2 ) /
     +                (1. + f_tmp.xslp**2 + f_tmp.yslp**2 ) 
     +                )
      endif

      ftk_add_delta = 0

      call ucopy ( f_tmp, f_out, FTRACK_WORD )

      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:44  eugenio
cInitial revision
c
cRevision 1.1  1998/02/13 23:08:32  kutschke
cNew routine.
c
c
