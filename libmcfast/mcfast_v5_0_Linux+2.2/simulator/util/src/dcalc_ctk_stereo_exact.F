      integer function dcalc_ctk_stereo_exact ( c, pos, eta, 
     +                                          dcalc, s3d, v1xv2 )

      implicit none
c
c Exact computation of the the distance of closest approach of
c a track to a stereo wire.  The algorithm is essentially the
c Trilling algorithm of using successive straight line approximations.
c
c Exceptions:
c  1) The sign convention for dcalc is the negative of CLEO's
c
c Inputs:
c c       - ctrack_structure
c
c pos(2)  - DFLOAT Array.  
c         - Any point on the wire, in the coordinate system specified
c           by (c.xref,c.yref,c.zref) and with axes parallel to the world
c           system.
c
c eta(3)  - a unit vector in the direction of the wire.
c
c Outputs: 
c dcalc   - signed distance of closest approach of the track to the wire.
c
c s3d     - DFLOAT
c         - arc length from current point on track to PCA.
c           The current point on the track is the PCA to a line parallel
c           to the z axis and which passes through (c.xref,c.yref).
c
c v1xv2   - A unit vector along the line of closest approach between the
c           track and the wire.  This is supplied to save the
c           derivative routine some CPU expensive work.
c
c Return Values: 0 all OK
c                1 error
C
C ---------------- Original CLEO comments -------------------------------
C
C     Code created by 
C
C     Robert Kutschke : kutschke@lns598.lns.cornell.edu
C     Anders Ryd      : ryd@charm.physics.ucsb.edu
C
C     Created : Sept 1994 -- June 1995
C     Title   : stereo_dist
C     Purpose : finds the point of closest approach of
C               a stereo wire and a track.
C     
C
C     Modifications:
C     April 3   96  ryd:Protect against a divison by zero that happens
C                   when the track is parallel to the wire. When this
C                   happens (abs(v1v2).gt.0.9999) consider the iteration
C                   to have converged and exit. 
C
C ---------------- End original CLEO comments ----------------------------


#include "const.inc"
#include "ctrack_struct.inc"

c     Calling arguments.
      record /ctrack_struct/ c
      DFLOAT pos(3)
      DFLOAT eta(3)
      DFLOAT dcalc
      DFLOAT s3d
      DFLOAT v1xv2(3)

c     Local variables.
      DFLOAT k,d0,phi,z,t,x0,y0,cx,cy

      DFLOAT q,x1(3),x2(3),v1(3),v2(3),inv2k,psi2,psi
      DFLOAT invcxy,invcsclambda,d0pinv2k,cphid0pinv2k
      DFLOAT sphid0pinv2k
      DFLOAT cqpsi,sqpsi,v1v2,s2,dpsi,cphi,sphi,spsi,cpsi
      DFLOAT x0t,y0t,s1,r,invv1xv2

c     Flag to signal that we had to abort out of the loop for one
c     reason or another.
      logical done

c     Loop counter.
      integer n

c     Maximum iteration count
      integer max_iter
      parameter ( max_iter = 50 )

c     Convergence criterion.  That the parabolic correction to the
c     drift distance be less than 1 micron.
      DFLOAT eps
      parameter ( eps = 1.e-6 * unit_meter )

c     Massage arguments into local variables.
      k   = c.cu
      d0  = c.da
      phi = c.phi0
      t   = c.ct
      z   = c.z0
      x0  = pos(1)
      y0  = pos(2)
      cx  = eta(1)/eta(3)
      cy  = eta(2)/eta(3)

c     Initialize status to success.
      dcalc_ctk_stereo_exact = 0

c     Start the oringal CLEO code.
      q=sign(1.0d0,k)

      psi=0.0

      inv2k=0.5/k
      
      invcxy=1.0/sqrt(cx**2+cy**2+1.0)
      invcsclambda=1.0/sqrt(1.0+t**2)
            
      d0pinv2k=d0+inv2k

      cphi=cos(phi)
      sphi=sin(phi)

      cphid0pinv2k=d0pinv2k*cphi
      sphid0pinv2k=d0pinv2k*sphi

      v1(1)=cx*invcxy
      v1(2)=cy*invcxy
      v1(3)=invcxy

      x1(1)=x0
      x1(2)=y0
      x1(3)=0.0

      x0t=-sin(phi)*d0pinv2k
      y0t=cos(phi)*d0pinv2k

      n=0

      done = .false.

c     Top of main iteration loop.
 10   continue
      cqpsi=cos(phi+q*psi)
      sqpsi=sin(phi+q*psi)
      v1v2=(cx*cqpsi+cy*sqpsi+t)*invcxy*invcsclambda
      x2(1)=-sphid0pinv2k+sqpsi*inv2k
      x2(2)=cphid0pinv2k-cqpsi*inv2k
      x2(3)=z+t*q*inv2k*psi
      v2(1)=cqpsi*invcsclambda
      v2(2)=sqpsi*invcsclambda
      v2(3)=t*invcsclambda
      if (abs(v1v2).gt.0.9999) then
         done = .true.
         goto 20
      endif
      s2=((x1(1)-x2(1))*(v1(1)*v1v2-v2(1))+
     +    (x1(2)-x2(2))*(v1(2)*v1v2-v2(2))+
     +    (x1(3)-x2(3))*(v1(3)*v1v2-v2(3)))/(v1v2**2-1.0)
      s1=s2*v1v2-v1(1)*(x1(1)-x2(1))-v1(2)*(x1(2)-x2(2))-
     +                                v1(3)*(x1(3)-x2(3))
      r=sqrt((x0t-(x1(1)+s1*v1(1)))**2+
     +                (y0t-(x1(2)+s1*v1(2)))**2)
      dpsi=s2*invcsclambda/r
      psi=psi+dpsi
      n=n+1

      if (n.gt.max_iter) then 
         print *, 'dcalc_ctk_stereo_exact: Too many iterations.'
         done = .true.
         dcalc_ctk_stereo_exact = 1
         goto 20
      endif


20    cqpsi=cos(phi+q*psi)
      sqpsi=sin(phi+q*psi)
      x2(1)=-sphid0pinv2k+sqpsi*inv2k
      x2(2)=cphid0pinv2k-cqpsi*inv2k
      x2(3)=z+t*q*inv2k*psi
      v2(1)=cqpsi*invcsclambda
      v2(2)=sqpsi*invcsclambda
      v2(3)=t*invcsclambda


      v1xv2(1)=v1(2)*v2(3)-v1(3)*v2(2)
      v1xv2(2)=v1(3)*v2(1)-v1(1)*v2(3)
      v1xv2(3)=v1(1)*v2(2)-v1(2)*v2(1)

      invv1xv2=1.0/sqrt(v1xv2(1)**2+v1xv2(2)**2+v1xv2(3)**2)

      v1xv2(1)=v1xv2(1)*invv1xv2
      v1xv2(2)=v1xv2(2)*invv1xv2
      v1xv2(3)=v1xv2(3)*invv1xv2

      dcalc=(x1(1)-x2(1))*v1xv2(1)+
     +      (x1(2)-x2(2))*v1xv2(2)+
     +      (x1(3)-x2(3))*v1xv2(3)

      s3d = psi * abs(inv2k) / invcsclambda

c     Return was forced above.
      if ( done ) return

c     Check convergence criteria.
      if (abs(2*s2**2*inv2k).gt.eps) goto 10

c     Normal return.
      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.2  2000/02/07 22:35:34  kutschke
c Linux does not like dsign - change to generic function, sign.
c
c Revision 1.1  1999/05/12  20:21:38  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c
