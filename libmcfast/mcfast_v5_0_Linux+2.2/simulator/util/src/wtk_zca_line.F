      integer function wtk_zca_line ( mode, v, vcov, w, wcov,
     +                                z_closest, err_z_closest )

c
c  Find the point of closest approach of a wtrack and the
c  line parallel to the z axis pasing through the vertex point v(x,y).
c
c  Return the z of this point and the error on z.
c
c  The wtrack is approximated by a straight line and it is the
c  responsibility of the user to ensure that that track is close enough
c  to the true point of closest approach for this approximation to be 
c  valid.
c
c  If mode is set to 0 the function only computes z_closest and not 
c  err_z_closest.If mode is set to 1 it computes both z_closest and 
c  err_z_closest.
c

#include "const.inc"
#include "wtrack_struct.inc"

c     Input:mode
c     mode = 0 only compute z_closest and not err_z_closest
c     mode = 1 compute both z_closest and err_z_closest
      integer mode

c     Input: (x,y,z) of the point and its covariance matrix
      DFLOAT v(3)
      DFLOAT vcov(3,3)

c     Input: Track information and its covariance matrix
      record /wtrack_struct /w
      DFLOAT wcov(7,7)
       
c     Output: Z on the track at the point of closest approach
      DFLOAT z_closest

c     Output: Error of the z
      DFLOAT err_z_closest

c     A large number
      DFLOAT large_number
      parameter ( large_number = 1.e36 )

c     Unit vector along the momentum direction.
      DFLOAT p_un(3)

c     Parameter such that (x,y,z)+ t * (p_un)
c     is the end of the line of closest approach.
      DFLOAT t

c     Momentum of the track and a point on the track.
      DFLOAT p(3), x(3)

c     Scalar product between p_un and (x,y,z).
      DFLOAT dot

c     Denominator in several expressions.
      DFLOAT denom

c     Derivative of z_closest wrt px, py, pz, E, x, y, z.
c     The derivative wrt E is simply zero.  In a wtrack E is considered
c     an independent free parameter and the mass is derived parameter.
c     Since the expression of z_closest does not depend directly on
c     E, this derivative is zero.
      DFLOAT dzdw(7)

c     Derivative of z_closest wrt v(1), v(2), v(3).
      DFLOAT dzdv(3)
       
c     Square of the contribution to err_z_closest from the error on the
c     track, on the vertex and their sum.
      DFLOAT sq_1, sq_2, sq_tot

      p(1) = w.px
      p(2) = w.py
      p(3) = w.pz
      x(1) = w.x
      x(2) = w.y
      x(3) = w.z

c     Compute the unit vector in the direction of the momentum.
      if ( w.p  .eq. 0. ) goto 666
      p_un(1) = p(1) / w.p
      p_un(2) = p(2) / w.p
      p_un(3) = p(3) / w.p

c     Check for zero denominator.
      denom = 1. - p_un(3)**2
      if ( denom .eq. 0. ) goto 670

c     Solve for t and z_closest.
      t = - ((x(1)-v(1)) * p_un(1) + (x(2)-v(2)) * p_un(2) ) / denom
      z_closest = x(3) + p_un(3) * t

      if ( mode .eq. 1 ) then

        dot   = x(1)* p_un(1) + x(2)* p_un(2) + x(3)* p_un(3)

c       Derivatives of z_closest wrt track and vertex parameters.
        dzdw(1) = - (x(1) * p_un(3) /(1 - p_un(3)**2))
        dzdw(2) = - (x(2) * p_un(3) /(1 - p_un(3)**2))
        dzdw(3) = t + (2* p_un(3) * p_un(3) *
     +                ( p_un(3)* x(3) - dot)) / denom
        dzdw(4) = 0.
        dzdw(5) = - p_un(1) * p_un(3)/(1 - p_un(3)**2)
        dzdw(6) = - p_un(2) * p_un(3)/(1 - p_un(3)**2)
        dzdw(7) = - p_un(3) * p_un(3)/(1 - p_un(3)**2)
	
	dzdv(1)= (p_un(1) * p_un(3))/(1 - p_un(3)**2)
	dzdv(2)= (p_un(2) * p_un(3))/(1 - p_un(3)**2)
	dzdv(3)= 0.
       
c       Compute the square of err_z_closest.
        sq_1 = 0.
        sq_2 = 0.
        call MxABAtr (1 , 7, dzdw, wcov, sq_1 )
        call MxABAtr (1 , 3, dzdv, vcov, sq_2 )
        sq_tot = sq_1 +  sq_2
	
        if (sq_tot .lt. 0.) goto 671
        err_z_closest = sqrt (sq_tot)

      else

        err_z_closest = large_number	
       
      endif

c     Normal return.
      wtk_zca_line = 0
      return
           
c     Error returns.
 666  wtk_zca_line  = 666
      z_closest     = large_number
      err_z_closest = large_number
      return

 670  wtk_zca_line  = 670
      z_closest     = large_number
      err_z_closest = large_number
      return

 671  wtk_zca_line  = 671
      z_closest     = large_number
      err_z_closest = large_number
      return
 
      end
