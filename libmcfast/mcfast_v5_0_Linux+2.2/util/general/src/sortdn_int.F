      subroutine sortdn_int(x, index, n)
c
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c Fast descending sort routine for intger data.
c The array x (length n) is sorted by changing "index".
c Based on the algorithm of D.L. shell, CACM 2, 30-32 (1959).
c See also D.E. Knuth: The Art of Computer Programming, vol. 3: Sorting
c and Searching, p. 84, Addison-Wesley (1973).
c
c Transferred from desy by Rainer Wilcke.
c
c  x      integer array (read)
c         Array of numbers to be sorted
c
c *index  integer array (write)
c         Returned array showing the order of the elements
c
c  n      integer variable (read)
c         Length of the array x
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

c
c     Calling arguments
      integer x(*)
      integer index(*), n
c
c     Local variables
      integer i, j, k, m, im, iw
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c
      do 5 i=1,n
        index(i) = i
5     continue
c
      m=n
   10 m=m/2
      if(m.eq.0) return
      k=n-m
      do 50 j=1,k
        i=j
   20   if(i.lt.1) go to 50
c
c 'ge' ==> sort in ascending order.
c 'le' ==> sort in descending order.
c
        if(x(index(i+m)).le.x(index(i))) go to 50
        im=i+m
c
c Exchange array elements to do sorting.
        iw = index(i)
        index(i) = index(im)
        index(im) = iw
        i=i-m
        go to 20
c
50    continue
c
      goto 10
c
      end
c$Id$
c$Log$
cRevision 1.1  2000/06/19 19:59:50  eugenio
cInitial revision
c
cRevision 1.2  1997/03/10 22:07:36  garren
cadd c$Log$
cadd cRevision 1.1  2000/06/19 19:59:50  eugenio
cadd cInitial revision
cadd c
c
