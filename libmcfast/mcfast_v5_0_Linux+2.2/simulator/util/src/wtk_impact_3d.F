      integer function wtk_impact_3d ( mode, w, wcov, m, mcov, 
     +                                 dd, err_dd )

c Given a wtrack and a vertex compute the 3D distance of closest approach
c (DCA) between the track and the vertex.  If requested, also compute the
c error on this distance, using the covariance matrices of the track and 
c the vertex.  The code works in an arbitrarily oriented magnetic field,
c so long as the field is constant along the trajectory from the 
c intial point to the PCA.
c
c For neutral tracks, for tracks with zero momentum and for charged tracks 
c in zero magnetic field, the problem is solved in closed form.
c
c For charged tracks in a non-zero magnetic field the algorithm is iterative:
c  1) Treat the track as a straight line and solve for the arclength to 
c     the DCA.
c  2) Step this arclength distance along the track helix.
c  3) Recompute the estimate in 1), starting from the position reached in 2.
c  4) If the estimate in 3) is small enough, then go to 5.  Otherwise go to 2.
c  5) Compute the DCA treating the track as a straight line at its present
c     position.
c
c The DCA is an unsigned quantity. It is defined even if the track has
c a momentum of zero.
c
c A caveat:
c    When computing the error on the distance, it is assumed that w
c    and m are independent. This will not be true if the vertex was 
c    fitted using the track w as one of its inputs.  See the comments
c    in wtk_impact_line_*.F for more details.
c
c A side note:
c    There are smarter ways to solve for the point of closest approach
c    for the case of the B field aligned with one of the coordinate axes.
c    While those methods also require an iteration, the iteration 
c    can be written more tightly than the one written here - however
c    I bet that much more time is spent in the transport of the covariance
c    matrix than is spent in the iteration.
c
c Convergence criterion:
c    This calculation assumes that there is no error in the non-bend
c    view, only in the bend view.
c    1) Project the computed step length onto the bend plane, 
c       l2d=l*sinth.
c    2) Now we need to think of working only in the 2D space of the
c       bend plane.  One quantity of possible interest is the
c       distance of closest approach between 2d projection of the
c       line and the 2d vertex point.  We do not need to compute this,
c       only the quadratic correction which comes from considering the
c       track to be a parabola, not a straight line.
c       quad_corr = 0.5*l2d**2/rho
c    3) Extrapolate the correction computed in 2) back to 3D, (divide
c       by sinth ).
c       quad_corr = quad_corr/sinth
c                 = 0.5*(l2d**2)/rho/sinth
c                 = 0.5*l**2*sinth/rho
c    4) If the quantity computed in 3) is small enough, then we are done.
c    
c    I suppose that I could add the correction computed in 3) onto dd.
c    However I have not worked out the sign.

      implicit none

#include "const.inc"
#include "wtrack_struct.inc"
#include "bfield_struct.inc"

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

      ! Magnetic field at initial track point.  Assumed to be constant
      ! along trajectory to the PCA.
      record /bfield_struct/ bf

      ! Working space.
      record /wtrack_struct/ w1, w2
      DFLOAT wc1(7,7)

      ! Linear estimate of 3d arclength from current point to PCA.
      DFLOAT l

      ! Transformation matrix.
      DFLOAT r(7,7)

      ! Return status of called routines.
      integer status

      ! Functions called.
      integer move_wtk_arc
      integer wtk_impact_3d_line, deriv_wtk_point

      ! Iteration counter and infinite loop trap.
      integer nloop, max_nloop
      parameter ( max_nloop = 10 )

      ! A large number
      DFLOAT large_number
      parameter ( large_number = 1.e36 )

      ! Radius of curvature in the bend plane.
      ! Sin of the polar angle of p, wrt the magnetic field direction.
      !
      ! These are assumed to be constant over the range
      ! that the track is transported and so are not recomputed as
      ! the track is moved.  They are only used in the
      ! computation of the convergence criteria and so need only be
      ! approximate.
      DFLOAT rad_curve, sinth

      ! Estimate of the quadratic correction to dd.  If this is 
      ! sufficiently small, then we are finished the iteration.
      DFLOAT quad_corr

      ! Convergence criterion: a cut on the quadratic correction.
      DFLOAT quad_corr_cut
      parameter ( quad_corr_cut = 1.0e-6*unit_meter )

      dd     = large_number
      err_dd = large_number

      ! Check for some of the easy cases.
      if ( w.p .eq. 0. .or. w.q .eq. 0. ) goto 900

      call get_bfield ( w.x, bf )

      ! Check for another easy case.
      if ( bf.bmag .eq. 0. ) goto 900

      call wtk_bend_plane_pars ( bf, w, rad_curve, sinth )

      l = -( (w.x-m(1))*w.px + (w.y-m(2))*w.py + 
     +       (w.z-m(3))*w.pz ) /w.p
      quad_corr = 0.5*(l**2)*sinth/rad_curve

      ! The last easy case.  We are already close enough to use
      ! the linear approximation.
      if ( quad_corr .lt. quad_corr_cut ) goto 900

      ! Not close enough.  Need to do some real work.
      call ucopy ( w, w1, WTRACK_WORD )

      ! Loop until we are close enough to the PCA.
      nloop = 0
      do while ( quad_corr .gt. quad_corr_cut )

         ! Move the track to the new point.
         status = move_wtk_arc(w1, l, bf, w2 )
         if ( status .ne. 0 ) goto 998

         ! Compute the convergence criterion.
         l = -( (w2.x-m(1))*w2.px + (w2.y-m(2))*w2.py + 
     +          (w2.z-m(3))*w2.pz ) / w2.p
         quad_corr = 0.5*(l**2)*sinth/rad_curve

         call ucopy ( w2, w1, WTRACK_WORD )

         nloop = nloop + 1
         if ( nloop .gt. max_nloop ) goto 999

      enddo

      ! Move the error matrix to the new point.
      if ( mode .ne. 0 ) then
          status = deriv_wtk_point(w, w1, bf, r)
          if ( status .ne. 0 ) goto 997 
          call vzero(wc1, 7*7*FLOAT_WORD)
          call MxABAtr(7, 7, r, wcov, wc1)
      endif

      ! We are close enough to get the right answer with the linear approx.
      wtk_impact_3d = wtk_impact_3d_line ( mode, w1, wc1,  m, mcov, 
     +                                     dd, err_dd )

      ! Normal return.
      return

      ! Do the easy cases.
 900  wtk_impact_3d = wtk_impact_3d_line ( mode, w,  wcov, m, mcov, 
     +                                     dd, err_dd )
      return

      ! Error returns.
 997  wtk_impact_3d = 3
      return

 998  wtk_impact_3d = 2
      return

      ! Add message log call here once message log works.
 999  wtk_impact_3d = 1
      return

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:46  eugenio
c Initial revision
c
c Revision 1.2  1998/04/27 02:17:09  kutschke
c New file.
c
c
