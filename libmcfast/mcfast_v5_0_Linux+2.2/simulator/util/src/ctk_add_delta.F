      integer function ctk_add_delta ( c_in, delta_c, bf, c_out )

c     Add the correction term, delta_c, to c_in.
c
c     This routine is used in the updating step of the Kalman filter so it
c     is possible that sometimes c_out.cu may be zero.  This is perfectly
c     well defined, unless one wants to calculate the momentum!  In this
c     case the momentum is set to some "safely large" value.
c
c     Also, it is OK for cu to change sign!

#include "const.inc"
#include "ctrack_struct.inc"
#include "bfield_struct.inc"


      ! Arguments.
      DFLOAT delta_c(5)
      record /ctrack_struct/ c_in, c_out, c_tmp
      record /bfield_struct/ bf

      ! Should make this a function of Ecm or call an access function
      ! to get it.
      DFLOAT pmax
      parameter ( pmax = 1000. )

      ! Functions.
      DFLOAT phi_norm

      DFLOAT a

      c_tmp.cu   = c_in.cu   + delta_c(1)
      c_tmp.phi0 = phi_norm(c_in.phi0 + delta_c(2))
      c_tmp.da   = c_in.da   + delta_c(3)
      c_tmp.ct   = c_in.ct   + delta_c(4)
      c_tmp.z0   = c_in.z0   + delta_c(5)
      c_tmp.u0   = cos(c_tmp.phi0)
      c_tmp.v0   = sin(c_tmp.phi0)
      c_tmp.q    = - sign(ONE,c_tmp.cu) * bf.bdir(3)
      c_tmp.xref = c_in.xref
      c_tmp.yref = c_in.yref
      c_tmp.zref = c_in.zref

      if ( c_tmp.cu .ne. 0. ) then
         a          = c_b * bf.bmag * bf.bdir(3) * c_in.q
         c_tmp.pt   = 0.5*abs(a/c_tmp.cu)
         c_tmp.p    = c_tmp.pt*sqrt( c_tmp.ct**2 + 1. )
      else
         c_tmp.p    = pmax
         c_tmp.pt   = c_tmp.p /sqrt( c_tmp.ct**2 + 1. )
      endif

      ctk_add_delta = 0

      call ucopy ( c_tmp, c_out, CTRACK_WORD )

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
