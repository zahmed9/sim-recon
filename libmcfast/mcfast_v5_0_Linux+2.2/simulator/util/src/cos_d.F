      real*8 function cos_d ( p )
c
c Compute the cos(theta) of a 3 or 4 vector.
c ( where the 4 vector is represented as (p(3),E) )
c
      real*8 p(4), ppp

      ppp = dsqrt ( p(1)**2 + p(2)**2 + p(3)**2 )
      if ( ppp .ne. 0. ) then
         cos_d = p(3)/ ppp
      else
         cos_d = 0.
      endif
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:55  garren
c add rcs log line
c
