      integer function wtk_impact_2d_line ( mode, w, wcov, m, mcov, 
     +                                  dd, err_dd )
c
c Given a straight line and a point, compute the 2D distance of closest 
c approach (DCA) between the line and the point ( in the x-y plane ).
c If requested, also compute the error on 
c this distance, using the covariance matrices of the line and the point.
c
c Note that the DCA is a signed quantity.
c
c A caveat:
c    When computing the error on the distance, it is assumed that w
c    and m are independent. This will not be true if the vertex was 
c    fitted using the track w as one of its inputs.  The result of
c    this is that dd/err_dd will be narrower than a unit gaussian
c    if this code is used to ask: does this track belong to a vertex
c    which included said track in the fit.
c    For vertices with a large number of tracks, such as primary
c    vertices, this will not be a practical problem - however the user 
c    should be aware of this problem when dealing with vertices with 
c    small numbers of tracks.  
c
c    The general solution to the problem is to do two vertex fits,
c    one including the track in question and the other excluding it; 
c    then compare the difference in chi2 between the two fits.

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"

      ! Input: Mode
      ! 0 = only compute dd, do not compute err_dd
      ! 1 = compute both dd and err_dd
      integer mode

      ! Input: Track information and covariance matrix.
      record /wtrack_struct/ w
      DFLOAT wcov(7,7)

      ! Input: Main vertex information and covariance matrix.
      DFLOAT m(3), mcov(3,3)

      ! Output: Unsigned 2D distance of closest approach from track to 
      !         main vertex.
      DFLOAT dd

      ! Output: Error on dd.
      DFLOAT err_dd

      ! Path length from secondary vertex to PCA to main vertex.
      DFLOAT l

      ! A parameter = l/pt.
      DFLOAT s

      ! 3-Momentum and space point pieces of w addresssable by indices.
      DFLOAT p(2), v(2)

      ! Displacement from main vertex to PCA to main vertex.
      DFLOAT d(2)

      ! Derivative of displacement components wrt wtrack components: 
      ! d d_i / d w_j
      DFLOAT dddw(3,7)

      ! Derivative of displacement components wrt main vertex components: 
      ! d d_i / d m_j
      DFLOAT dddm(3,3)

      ! Derivative of unit vector components wrt to vector components.
      DFLOAT fac(2)

      ! Derivative of dd wrt wtrack components.
      DFLOAT dervw(7)

      ! Derivative of dd wrt main vertex components.
      DFLOAT dervm(3)

      ! Error squared on dd.
      DFLOAT errsq

      ! Contribution to errsq from wtrack information.
      DFLOAT t1

      ! Contribution to errsqfrom main vertex.
      DFLOAT t2

      ! Indexology.
      integer i, j, k

      ! A large number
      DFLOAT large_number
      parameter ( large_number = 1.e36 )

      if ( w.pt .eq. 0. ) goto 500

      ! Find the PCA and the DCA.
      l = -( (w.x-m(1))*w.px + (w.y-m(2))*w.py )/w.pt
      s = l/w.pt
      d(1) = w.x + s*w.px - m(1)
      d(2) = w.y + s*w.py - m(2)
      dd   = ( -d(1)*w.py + d(2)*w.px )/w.pt

      ! Only compute error matrix if asked to.
      if ( mode .eq. 0 ) then
         wtk_impact_2d_line = 0
         err_dd             = large_number
         return
      endif

      v(1) = w.x
      v(2) = w.y
      p(1) = w.px
      p(2) = w.py
      call vzero ( dddw, 3*7*FLOAT_WORD )
      call vzero ( dddm, 3*3*FLOAT_WORD )

      ! Compute derivatives.
      do i = 1, 2

        ! Momentum parts of dddw.
        do j = 1, 2
           if ( j .eq. i ) dddw(i,j) = s
           dddw(i,j) = dddw(i,j) - ( v(j)-m(j) )*p(i)/w.pt/w.pt -
     +                 2.*s*p(j)*p(i)/w.pt/w.pt
        enddo

        ! Space parts of dddw and all of dddm.
        do j = 5, 6
           k = j-4
           if ( k .eq. i ) dddw(i,j) = 1.
           dddw(i,j) =  dddw(i,j) - p(i)*p(k)/w.pt/w.pt
           dddm(i,k) = -dddw(i,j)
        enddo

      enddo

      if ( dd .ne. 0. ) then
         fac(1) = d(1)/dd
         fac(2) = d(2)/dd
      else
         fac(1) = 1./sqrt(2.d0)
         fac(2) = 1./sqrt(2.d0)
      endif

      do k = 1, 7
        dervw(k) = (fac(1)*dddw(1,k) + fac(2)*dddw(2,k) )
      enddo

      do k = 1, 3
        dervm(k) = (fac(1)*dddm(1,k) + fac(2)*dddm(2,k) )
      enddo

      ! End of computation of derivatives.

      ! Now compute the errors-squared.
      t1 =  dervw(1)*wcov(1,1)*dervw(1) + 
     +      dervw(2)*wcov(2,2)*dervw(2) +
     +      dervw(5)*wcov(5,5)*dervw(5) +
     +      dervw(6)*wcov(6,6)*dervw(6) +
     + 2.*( dervw(1)*wcov(1,2)*dervw(2) +
     +      dervw(1)*wcov(1,5)*dervw(5) +
     +      dervw(1)*wcov(1,6)*dervw(6) +
     +      dervw(2)*wcov(2,5)*dervw(5) +
     +      dervw(2)*wcov(2,6)*dervw(6) +
     +      dervw(5)*wcov(5,6)*dervw(6)  )

      t2 =  dervm(1)*mcov(1,1)*dervm(1) + 
     +      dervm(2)*mcov(2,2)*dervm(2) +
     +   2.*dervm(1)*mcov(1,2)*dervm(2)  
      errsq = t1 + t2

      if ( errsq .lt. 0. ) goto 999

      err_dd             = sqrt(errsq)
      wtk_impact_2d_line = 0
      return

      ! Treat the case that the transverse momentum is zero.
 500  d(1) = w.x-m(1)
      d(2) = w.y-m(2)
      dd   = sqrt( d(1)**2 + d(2)**2 )

      ! Only compute error matrix if asked to.
      if ( mode .eq. 0 ) then
         wtk_impact_2d_line = 0
         err_dd             = large_number
         return
      endif

      if ( dd .ne. 0. ) then
         dervw(5) = d(1)/dd
         dervw(6) = d(2)/dd
      else
         dervw(5) = 1./sqrt(2.)
         dervw(6) = 1./sqrt(2.)
      endif
      dervm(1) = -dervw(5)
      dervm(2) = -dervw(6)

      t1 =  dervw(5)*wcov(5,5)*dervw(5) +
     +      dervw(6)*wcov(6,6)*dervw(6) +
     +   2.*dervw(5)*wcov(5,6)*dervw(6)

      t2 =  dervm(1)*mcov(1,1)*dervm(1) + 
     +      dervm(2)*mcov(2,2)*dervm(2) +
     +   2.*dervm(1)*mcov(1,2)*dervm(2)  
      errsq = t1 + t2

      if ( errsq .lt. 0. ) goto 999

      err_dd = sqrt(errsq)
      wtk_impact_2d_line = 0
      return

      ! Error returns.
 999  wtk_impact_2d_line = 1
      dd                 = large_number
      err_dd             = large_number
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 02:17:18  kutschke
c New file.
c
c
