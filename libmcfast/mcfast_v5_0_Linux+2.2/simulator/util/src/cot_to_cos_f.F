      real*4 function cot_to_cos_f ( c )
c
c Given cotangent(theta), return cosine(theta).
c
      ! Cotangent(theta)
      real*4 c

      cot_to_cos_f = c / sqrt ( 1.  + c*c )
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:57  garren
c add rcs log line
c
