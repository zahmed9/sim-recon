      subroutine print_cov ( s, m, c )
c
c Rob Kutschke, Nov 9, 1998.
c
c Print a covariance matrix in lower triangle form.
c The format is:
c
c    s
c    r s
c    r r s 
c    r r r s
c    .........
c
c Where s is a an error ( ie sqrt(cov(i,i)) ) and where r is a correlation
c coefficenty, ie cov(i,j)/sqrt(cov(i,i)*cov(j,j)).
c
c

#include "const.inc"

c Arguments.

c     Input: a tag string to identify this printout.
      character*(*) s

c     Input: dimension of arrays.
      integer m

c     Input: the covariance matrix to be printed.
      DFLOAT c(m,m)

c Local variables.

c     Indexology.
      integer i, j

c     Temporary space to hold errors on diagonal and a covariance
c     matrix elsewhere.
      DFLOAT sig(7,7)

      call vzero ( sig, 49*FLOAT_WORD )

      if ( m .gt. 7 ) then
         print *, 'Giving up in print_cov.  Requested dimension: ', m
         print *, s
         return
      endif

      do i = 1, m
        if ( c(i,i) .gt. 0. ) then
           sig(i,i) = sqrt(c(i,i))
        else
           sig(i,i) = -1.
        endif
      enddo

      do i = 1, m
        do j = 1, i-1
           if ( sig(i,i) .gt. 0. .and. sig(j,j) .gt. 0. ) then
              sig(i,j) = c(i,j)/sig(i,i)/sig(j,j)
           else
              sig(i,j) = -2.
           endif
        enddo
      enddo
             

      do i = 1, m
         print 123, s, ( sig(i,j), j=1,i)
      enddo
 123  format ( a, 7f20.11 )

      end
