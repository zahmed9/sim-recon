      real*8 function eta_d ( p )
c
c Compute the eta of a 3 or 4 vector.
c ( where the 4 vector is represented as (p(3),E) )
c
      ! Input 3 or 4 vector.
      real*8 p(4)

      ! Functions.
      real*8 cos_d, cos_to_eta_d

      eta_d = cos_to_eta_d(cos_d(p))
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:30  garren
c add rcs log line
c
