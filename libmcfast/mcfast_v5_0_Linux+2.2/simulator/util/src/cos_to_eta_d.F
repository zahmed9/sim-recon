      real*8 function cos_to_eta_d ( cos )

c Convert cos(theta) to eta, where eta is the pseudo rapidity
c and theta is the polar angle, both wrt the z axis.

      real*8 eta, cos, sin2

      sin2 = 1. - cos**2 
      if ( sin2 .le. 0.  ) then
         eta = 100.
      else
         eta = -log ( dsqrt(sin2)/ ( 1.d0 + dabs(cos) ) )
      endif
      cos_to_eta_d = sign(eta,cos)

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.4  2000/02/07 22:35:33  kutschke
c Linux does not like dsign - change to generic function, sign.
c
c Revision 1.3  1997/04/04  20:30:56  garren
c add rcs log line
c
