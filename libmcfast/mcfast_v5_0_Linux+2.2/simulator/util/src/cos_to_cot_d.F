      real*8 function cos_to_cot_d ( c )
c
c Given cossine(theta), return cotangent(theta)
c
      ! cosine(theta)
      real*8 c

      cos_to_cot_d = c / sqrt( 1. - c*c )
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:55  garren
c add rcs log line
c
