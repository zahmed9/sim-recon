      subroutine calc_dkl_d ( mode, x1, v1, x2, v2, dist, sdist )

c Mode = 0 Given two points, compute the distance between the two points.
c          Set the error on the distance to a large number.
c Mode = 1 Given two points, with their 3x3 error matrices, compute
c          the distance between the two points and the error on that 
c          distance.
c
c It is assumed that the two points are the results of independent 
c measurements and, therefore, the 6x6 error matrix of d is two 
c independent 3x3 error matrices.
c
c If the error**2 is negative, then sdist is left as the error**2.

! Arguments

      ! Mode control
      integer mode

      ! The two points and their error matrices.
      real*8 x1(3), v1(3,3) 
      real*8 x2(3), v2(3,3) 

      ! Distance between the two points.  Error on that distance,
      ! and the squares of that error.
      real*8 dist, sdist, s2dist

! Local variables.
      ! Difference vector.
      real*8 dx(3)

      ! Derivative vector.
      ! Note that: d dist / d x2(i) = - d dist / d x1(i)
      ! However, 
      ! a) there are no x1-x2 cross terms ( assumption of 
      !    independent measurements ), and
      ! b) all terms in s2dist are quadratic in the derivatives,
      ! therefore, we do not need to keep track of the sign and we
      ! need just the one derivative vector.
      real*8 deriv(3)

      real*8 large_number
      parameter ( large_number = 1.e30 )

      ! Compute difference vector and length.
      dx(1) = x1(1) - x2(1)
      dx(2) = x1(2) - x2(2)
      dx(3) = x1(3) - x2(3)
      dist  = sqrt( dx(1)**2 + dx(2)**2 + dx(3)**2 )
      if ( mode .eq. 0 ) then
         sdist = large_number
         return
      endif

      ! Compute derivative vector.
      if ( dist .ne. 0. ) then
         deriv(1) = dx(1)/dist
         deriv(2) = dx(2)/dist
         deriv(3) = dx(3)/dist
      else
         deriv(1) = 1.
         deriv(2) = 1.
         deriv(3) = 1.
      endif

      ! Matrix equation:
      ! s2dist = (deriv(transpose))( v1 + v2 ) ( deriv )
      s2dist = deriv(1)*deriv(1)*( v1(1,1) + v2(1,1) ) +
     +         deriv(2)*deriv(2)*( v1(2,2) + v2(2,2) ) +
     +         deriv(3)*deriv(3)*( v1(3,3) + v2(3,3) ) +
     +   2.* ( deriv(1)*deriv(2)*( v1(1,2) + v2(1,2) ) +
     +         deriv(1)*deriv(3)*( v1(1,3) + v2(1,3) ) +
     +         deriv(2)*deriv(3)*( v1(2,3) + v2(2,3) )   )

      if ( s2dist .gt. 0. ) then
         sdist = sqrt(s2dist)
      else
         sdist = s2dist
      endif

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:42  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:30:54  garren
c add rcs log line
c
