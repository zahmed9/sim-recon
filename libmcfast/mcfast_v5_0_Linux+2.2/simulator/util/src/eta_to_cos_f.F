      real*4 function eta_to_cos_f ( eta )

c Convert eta to cos(theta), where eta is the pseudo rapidity
c and theta is the polar angle, both wrt the z axis.

      real*4 eta, cos

      cos = ( 1.d0 - dexp(-2.d0*abs(eta)) )/ 
     +      ( 1.d0 + dexp(-2.d0*abs(eta)))
      eta_to_cos_f = sign(cos,eta)
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:32  garren
c add rcs log line
c
