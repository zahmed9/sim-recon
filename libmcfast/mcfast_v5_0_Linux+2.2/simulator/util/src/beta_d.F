      real*8 function beta_d ( p )

c Compute the beta of a momentum 4-vector.

      ! Input 4-vector.
      real*8 p(4)

      ! Functions.
      real*8 v3mag_d

      if ( p(4) .gt. 0. ) then
         beta_d = v3mag_d(p)/p(4)
      else
         beta_d = 1.
      endif

      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:42  eugenio
cInitial revision
c
cRevision 1.4  1997/02/21 20:13:58  kutschke
cAdd Log and Id fields
c
