      real*4 function beta_f ( p )

c Compute the beta of a momentum 4-vector.

      ! Input 4-vector.
      real*4 p(4)

      ! Functions.
      real*4 v3mag_f

      if ( p(4) .gt. 0. ) then
         beta_f = v3mag_f(p)/p(4)
      else
         beta_f = 1.
      endif

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:52  garren
c add rcs log line
c
