      real*4 function v4mag_r ( a )
c
c Compute the magnitude of a 4 vector.
c Protect against a negative mass squared.  Under normal circumstances
c round off error can sometimes cause photons to have a negative
c invariant mass squared.
c
      real*4 a(4)

      v4mag_r = sqrt( amax1(a(4)**2 - a(1)**2 - a(2)**2 - a(3)**2, 
     +                0.0 ) )
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:59  garren
c add rcs log line
c
