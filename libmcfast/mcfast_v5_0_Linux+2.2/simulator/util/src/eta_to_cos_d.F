      real*8 function eta_to_cos_d ( eta )

c Convert eta to cos(theta), where eta is the pseudo rapidity
c and theta is the polar angle, both wrt the z axis.

      real*8 eta, cos

      cos = ( 1.d0 - dexp(-2.d0*dabs(eta)) )/ 
     +      ( 1.d0 + dexp(-2.d0*dabs(eta)))
      eta_to_cos_d = sign(cos,eta)
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.4  2000/02/07 22:35:34  kutschke
c Linux does not like dsign - change to generic function, sign.
c
c Revision 1.3  1997/04/04  20:31:31  garren
c add rcs log line
c
