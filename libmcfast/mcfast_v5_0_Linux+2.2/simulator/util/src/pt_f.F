      real*4 function pt_f ( a )
c
c Compute the Pt of  2, 3 or 4 vector.
c ( where the 4 vector is represented as (P(3),E)  )
c
      real*4 a(4)

      pt_f = sqrt( a(1)**2 + a(2)**2 )
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:57  garren
c add rcs log line
c
