      real*8 function v3mag_d ( a )
c
c Compute the magnitude of a 3 vector.
c
      real*8 a(3)

      v3mag_d = dsqrt( a(1)**2 + a(2)**2 + a(3)**2 )
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:58  garren
c add rcs log line
c
