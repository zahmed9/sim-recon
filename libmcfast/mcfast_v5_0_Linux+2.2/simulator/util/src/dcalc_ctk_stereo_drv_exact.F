      integer function dcalc_ctk_stereo_drv_exact ( c, pos, eta, 
     +                                              dcalc, derv, s3d  )
c
c Compute the distance of closest approach of a track to a wire
c and the derivatives of that distance wrt the track parameters.
c Do an exact computation, including the effects of curvature.
c
c This routine breaks the model of most of the other routines in MCFast
c by returning both the derivatives and the drift distance. The reason
c is that the CPU expensive part of the calculation is common to both.
c
c Inputs:
c c       - ctrack_structure
c 
c pos(2)  - DFLOAT Array.  
c         - Any point on the wire, in the coordinate system specified
c           by (c.xref,c.yref,c.zref) and with axes parallel to the world
c           system.
c
c eta   - DFLOAT Array
c       - a unit vector in the direction of the wire
c
c Outputs:
c dcalc - The computed drift distance
c
c derv  - The derivatives of the drift distance wrt the track parameters.
c
c s3d     - DFLOAT
c         - arc length from current point on track to PCA.
c           The current point on the track is the PCA to a line parallel
c           to the z axis and which passes through (c.xref,c.yref).
c
C ---------------- Original CLEO comments -------------------------------
C
C     Code created by 
C
C     Robert Kutschke : kutschke@lns598.lns.cornell.edu
C     Anders Ryd      : ryd@charm.physics.ucsb.edu
C
C     Created : Sept 1994 -- June 1995
C     Title   : cleostereoder
C     Purpose : this routine calculates the derivatives with respect to
C               the track parameters for the distance of closest aproach
C               of the track to a stereo-wire
C     
C
C     Modifications:
C
C
C
C ---------------- End original CLEO comments ----------------------------

      implicit none

#include "const.inc"
#include "ctrack_struct.inc"

c     Arguments.
      record /ctrack_struct/ c
      DFLOAT pos(2)
      DFLOAT eta(3)
      DFLOAT dcalc
      DFLOAT derv(5)
      DFLOAT s3d

c     Functions called.
      integer  dcalc_ctk_stereo_exact
      external dcalc_ctk_stereo_exact

c     Local variables
      integer status

c     Track parameters.
      DFLOAT k,d0,phi,z,t

c     Turning angle from current point on the track to the PCA to the wire.
      DFLOAT psi

c     A unit vector along the line of closest approach between the
c     track and the wire.
      DFLOAT v1xv2(3)

      DFLOAT sphi,cphi,q,rho,sqpsi,cqpsi
      DFLOAT xt,yt
      DFLOAT dxtdk,dytdk,dztdk,dxtdd0,dytdd0
      DFLOAT dxtdphi,dytdphi,dztdt,inv2k,inv2k2
      DFLOAT x(3), cx, cy, sinth

c     Massage arguments into local variables.
      k   = c.cu
      phi = c.phi0
      d0  = c.da
      t   = c.ct
      z   = c.z0

      inv2k  = 0.5/k
      inv2k2 = inv2k/k
      rho    = abs(inv2k)
      sinth  = 1./sqrt(1.+t**2)

c     Compute PCA to wire, arc length to PCA and the third Trilling vector.
      status = dcalc_ctk_stereo_exact ( c, pos, eta, dcalc, s3d, v1xv2 )
      if ( status .ne. 0 ) goto 9999

      psi = s3d * sinth / rho

      sphi=sin(phi)
      cphi=cos(phi)
      q=sign(1.0d0,k)

      sqpsi=sin(phi+q*psi)
      cqpsi=cos(phi+q*psi)

      xt=-d0*sphi+(sqpsi-sphi)*inv2k
      yt=d0*cphi+(cphi-cqpsi)*inv2k

      dxtdk=-(sqpsi-sphi)*inv2k2
      dytdk=-(cphi-cqpsi)*inv2k2
      dztdk=-t*q*psi*inv2k2

      dxtdd0=-sphi
      dytdd0=cphi
    
      dxtdphi=-yt
      dytdphi=xt

      dztdt=rho*psi
      
      derv(1)=v1xv2(1)*dxtdk+v1xv2(2)*dytdk+v1xv2(3)*dztdk
      derv(2)=v1xv2(1)*dxtdphi+v1xv2(2)*dytdphi
      derv(3)=v1xv2(1)*dxtdd0+v1xv2(2)*dytdd0
      derv(4)=v1xv2(3)*dztdt
      derv(5)=v1xv2(3)

      ! Avery convention
      derv(1) = - derv(1)
      derv(2) = - derv(2)
      derv(3) = - derv(3)
      derv(4) = - derv(4)
      derv(5) = - derv(5)

c     Normal return.
      dcalc_ctk_stereo_drv_exact = 0
      return

c     Error return.
 9999 dcalc_ctk_stereo_drv_exact = status

      end
c
c $Id$
c
c $Log$
c Revision 1.1  2000/06/19 19:59:43  eugenio
c Initial revision
c
c Revision 1.1  1999/05/12 20:21:38  kutschke
c 21 files changed/added to implement ctk Kalman filter.
c
c
