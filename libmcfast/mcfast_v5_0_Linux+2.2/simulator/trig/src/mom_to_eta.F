      subroutine mom_to_eta(w, pt, eta, phi, ier)
c--------------------------------------------
c     Purpose:  return transverse momentum, eta, phi 
c     inputs    p(3) -- three momentum
c     output    pt   -- transverse momentum
c               eta  -- pseudo-rapidity, eta = -alog(tan(theta/2)
c                       theta = acos(p(3)/ptot)
c               phi  -- running from 0 to twopi
c               ier  -- 0 if all is well
c                       1 if magnitude was adjusted to prevent /0.
c                       2 if px was adjusted to prevent /0.
c                       3 if track is far,far forward
c
c     created  21-mar-1994  A. Boehnlein
c-------------------------------------------- 
      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

c     Externals
      external phi_norm
      DFLOAT   phi_norm

c     Calling arguments
      record /wtrack_struct/ w
      real pt, eta, phi
      integer ier
c--------------------------------------------

      ier = 0
      pt  = w.pt
      phi = phi_norm(atan2(w.py, w.px))

c     eta = -ln(tan(theta/2)) = -0.5*ln[(1-costh)/(1+costh)] = -ln[pt/(p+pz)]
      if( w.pt .gt. 0. ) then
            eta = -log( w.pt / (w.p+abs(w.pz)) )
            eta = eta * sign(ONE, w.pz)
      else
           ier = 3
           eta = 100.*sign(ONE, w.pz)
      endif

      return
      end     

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:39  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:30:37  garren
c add rcs log line
c

