      subroutine wtoeta(w, eta, phi, theta, error) 
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c    From w track info: find eta, theta and phi
c
c    Returns  phi and theta in degrees
c
c    if error :         returns error  > 0
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "wtrack_struct.inc"
#include "const.inc"

c     Externals
      external phi_norm
      DFLOAT   phi_norm

c     Calling arguments
      integer error
      DFLOAT eta, phi, theta
      record /wtrack_struct/ w

c     Local variables
c>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

       if(w.p .le. 0.0 .or. w.pt .le. 0.0) then
         error = 1
         return
       endif

       phi = phi_norm(atan2( w.py, w.px ))     ! does not use vertex info
       phi = phi*180. / pi

       theta = acos(w.pz/w.p)

c old  eta = -alog(tan(theta/2.)),w.pz)

       if(w.pt .eq. 0.) then
         eta = 100.
       else
         eta = -log(w.pt /( w.p+abs(w.pz) ))
       endif
       eta =  eta*sign(ONE,w.pz)

       theta = theta*180./pi

       error = 0

       return
       end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:47  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:04  garren
c add rcs log line
c
