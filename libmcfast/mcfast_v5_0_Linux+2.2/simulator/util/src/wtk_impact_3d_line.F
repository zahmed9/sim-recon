      integer function wtk_impact_3d_line ( mode, w, wcov, m, mcov, 
     +                                      dd, err_dd )
c
c Given a wtrack and a point, assume that the track can be reliably
c extrapolated as a straight line and compute the distance of closest approach 
c DCA between the line and the point.  If requested, also compute the error
c on this distance, using the covariance matrices of the line and the point.
c
c The DCA is an unsigned quantity. It is defined even if the track has
c a momentum of zero.
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

      ! Output: Unsigned distance of closest approach from track to 
      !         main vertex.
      DFLOAT dd

      ! Output: Error on dd.
      DFLOAT err_dd

      ! Path length from secondary vertex to PCA to main vertex.
      DFLOAT l

      ! A parameter = l/p.
      DFLOAT s

      ! 3-Momentum and space point pieces of w addresssable by indices.
      DFLOAT p(3), v(3)

      ! Displacement from main vertex to PCA to main vertex.
      DFLOAT d(3)

      ! Derivative of displacement components wrt wtrack components: 
      ! d d_i / d w_j
      DFLOAT dddw(3,7)

      ! Derivative of displacement components wrt main vertex components: 
      ! d d_i / d m_j
      DFLOAT dddm(3,3)

      ! Derivative of unit vector components wrt to vector components.
      DFLOAT fac(3)

      ! Derivative of dd wrt wtrack components.
      DFLOAT dervw(7)

      ! Derivative of dd wrt main vertex components.
      DFLOAT dervm(3)

      ! Error squared on dd.
      DFLOAT errsq

      ! Contribution to errsq from wtrack information.
      DFLOAT t1

      ! Contribution to errsq from main vertex.
      DFLOAT t2

      ! Indexology.
      integer i, j, k

      ! Temporary for call to calc_dkl_d.
      DFLOAT tcov(3,3)

      ! A large number
      DFLOAT large_number
      parameter ( large_number = 1.e36 )

      ! Treat this case specially.
      if ( w.p .eq. 0. ) goto 500

      ! Find the PCA and the DCA.
      l = -( (w.x-m(1))*w.px + (w.y-m(2))*w.py + (w.z-m(3))*w.pz )/w.p
      s = l/w.p
      d(1) = w.x + s*w.px - m(1)
      d(2) = w.y + s*w.py - m(2)
      d(3) = w.z + s*w.pz - m(3)
      dd   = sqrt ( d(1)**2 + d(2)**2 + d(3)**2 )

      ! Only compute the error if asked to.
      if ( mode .eq. 0 ) then
         wtk_impact_3d_line = 0
         err_dd             = large_number
         return
      endif

      v(1) = w.x
      v(2) = w.y
      v(3) = w.z
      p(1) = w.px
      p(2) = w.py
      p(3) = w.pz
      call vzero ( dddw, 3*7*FLOAT_WORD )
      call vzero ( dddm, 3*3*FLOAT_WORD )

      ! Compute derivatives.
      do i = 1, 3

        ! Momentum parts of dddw.
        do j = 1, 3
           if ( j .eq. i ) dddw(i,j) = s
           dddw(i,j) = dddw(i,j) - ( v(j)-m(j) )*p(i)/w.p/w.p -
     +                 2.*s*p(j)*p(i)/w.p/w.p
        enddo

        ! Space parts of dddw and all of dddm.
        do j = 5, 7
           k = j-4
           if ( k .eq. i ) dddw(i,j) = 1.
           dddw(i,j) =  dddw(i,j) - p(i)*p(k)/w.p/w.p
           dddm(i,k) = -dddw(i,j)
        enddo

      enddo

      if ( dd .ne. 0. ) then
         fac(1) = d(1)/dd
         fac(2) = d(2)/dd
         fac(3) = d(3)/dd
      else
         fac(1) = 1./sqrt(3.0)
         fac(2) = 1./sqrt(3.0)
         fac(3) = 1./sqrt(3.0)
      endif

      do k = 1, 7
        dervw(k) = (fac(1)*dddw(1,k) + fac(2)*dddw(2,k) + 
     +                                 fac(3)*dddw(3,k)  )
      enddo

      do k = 1, 3
        dervm(k) = (fac(1)*dddm(1,k) + fac(2)*dddm(2,k) + 
     +                                 fac(3)*dddm(3,k)  )
      enddo

      ! End of computation of derivatives.

      ! Now compute the errors-squared.
      t1 = 0.
      t2 = 0.
      call MxABAtr ( 1, 7, dervw, wcov, t1 )
      call MxABAtr ( 1, 3, dervm, mcov, t2 )
      errsq = t1 + t2

      if ( errsq .lt. 0. ) goto 999

      err_dd = sqrt(errsq)
      wtk_impact_3d_line = 0

      ! Normal return.
      return

      ! If the momentum is zero, then return the decay length and its error.
 500  tcov(1,1) = wcov(5,5)
      tcov(2,1) = wcov(6,5)
      tcov(3,1) = wcov(7,5)
      tcov(1,2) = wcov(5,6)
      tcov(2,2) = wcov(6,6)
      tcov(3,2) = wcov(7,6)
      tcov(1,3) = wcov(5,7)
      tcov(2,3) = wcov(6,7)
      tcov(3,3) = wcov(7,7)
      call calc_dkl_d ( mode, w.x, tcov, m, mcov, dd, err_dd )
      wtk_impact_3d_line = 0
      return

      ! Error returns.
      ! Add message log calls once utility is available.
 999  wtk_impact_3d_line = 1
      dd          = large_number
      err_dd      = large_number
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 02:17:13  kutschke
c New file.
c
c
