      real*4 function eta_f ( p )
c
c Compute the eta of a 3 or 4 vector.
c ( where the 4 vector is represented as (p(3),E) )
c
      ! Input 3 or 4 vector.
      real*4 p(4)

      ! Functions.
      real*4 cos_f, cos_to_eta_f

      eta_f = cos_to_eta_f(cos_f(p))
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:31  garren
c add rcs log line
c
