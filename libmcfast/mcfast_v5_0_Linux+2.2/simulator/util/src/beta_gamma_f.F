      real*4 function beta_gamma_f ( p )

c Compute the beta of a momentum 4-vector.

      ! Input 4 vector.
      real*4 p(4)

      ! Functions.
      real*4 v3mag_f, v4mag_f

      if ( v4mag_f(p) .gt. 0. ) then
         beta_gamma_f = v3mag_f(p)/v4mag_f(p)
      else
         if ( v3mag_f(p) .eq. 0. ) then
            beta_gamma_f = 0.
         else
            beta_gamma_f = 1.
         endif
      endif

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.4  1997/04/04 20:30:53  garren
c add rcs log line
c
