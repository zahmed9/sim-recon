      subroutine deisrs1(nm,n,ar,wr,zr,ierr,work)
c     all eigenvalues and corresponding eigenvectors of a real
c     symmetric matrix
c
      double precision ar(nm,nm),wr(n),zr(nm,nm),work(1)
c  -------------------------------------------------

      call dtred2(nm,n,ar,wr,work,zr)
      call dtql2(nm,n,wr,work,zr,ierr)
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:31:19  garren
c add rcs log line
c
