      integer function err_tau ( w, wcov, v, vcov, tau, sigtau )

c     Compute the proper decay time, tau, for a particle which is
c     produced at the primary vertex and which is decayed at some 
c     secondary vertex. 

c     Try to do something sensible in the impossible case that beta*gamma
c     is zero but d is non-zero.

#include "const.inc"
#include "wtrack_struct.inc"

      ! w track of the B candidate and its full covariance matrix,
      ! including the momentum-space cross terms.
      record /wtrack_struct/ w
      DFLOAT wcov(7,7)

      ! Main vertex and its covariance matrix.
      DFLOAT v(3), vcov(3,3)
            
      ! Proper decay time and its error.
      DFLOAT tau, sigtau

      ! Decay length and its error.
      DFLOAT d

      ! beta*gamma 
      DFLOAT bg

      ! Square of the error on the proper lifetime.
      DFLOAT sigsq_tau

      ! Derivatives of the proper time wrt the w track parameters and
      ! wrt the main vertex parameters.
      DFLOAT derw(7), derv(3)

      ! Stuff
      DFLOAT facd, facp
      DFLOAT t1, t2, t3

      ! Functions.
      DFLOAT beta_gamma_d

      d  = sqrt ( (w.x-v(1))**2 + (w.y-v(2))**2 + (w.z-v(3))**2 )
      bg = beta_gamma_d(w.px)
      if ( bg .ne. 0. ) then
         tau = d/bg/clight
      else
         if ( d .eq. 0. ) then
            tau = 0.
         else
            tau = 1.e36
         endif
         goto 999
      endif

      facp = - tau/w.p/w.p
      facd =   tau/d/d
      derw(1) = - facp*w.px
      derw(2) = - facp*w.py
      derw(3) = - facp*w.pz
      derw(4) =   0.
      derw(5) =   facd*(w.x-v(1))
      derw(6) =   facd*(w.y-v(2))
      derw(7) =   facd*(w.z-v(3))
      derv(1) = - derw(5)
      derv(2) = - derw(6)
      derv(3) = - derw(7)

      t1 = 0.
      t2 = 0.
      call MxABAtr ( 1, 7, derw, wcov, t1 )
      call MxABAtr ( 1, 3, derv, vcov, t2 )
      sigsq_tau = t1 + t2

      if ( sigsq_tau .lt. 0. ) goto 999
      sigtau = sqrt(sigsq_tau)

      ! Normal return.
      err_tau = 0
      return

      ! Error return.
 999  sigtau = 1.e36
      err_tau = 1
      return
      end
c
c$Id$
c
c$Log$
cRevision 1.1  2000/06/19 19:59:44  eugenio
cInitial revision
c
cRevision 1.3  1998/04/27 02:18:10  kutschke
creal*8 to DFLOAT
c
c Revision 1.2  1997/04/04  08:20:02  kutschke
c New routine.
c
