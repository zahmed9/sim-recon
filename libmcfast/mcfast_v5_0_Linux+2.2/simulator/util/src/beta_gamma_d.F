      real*8 function beta_gamma_d ( p )

c Compute the beta of a momentum 4-vector.

      ! Input 4 vector.
      real*8 p(4)

      ! Functions.
      real*8 v3mag_d, v4mag_d

      if ( v4mag_d(p) .gt. 0. ) then
         beta_gamma_d = v3mag_d(p)/v4mag_d(p)
      else
         if ( v3mag_d(p) .eq. 0. ) then
            beta_gamma_d = 0.
         else
            beta_gamma_d = 1.
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

