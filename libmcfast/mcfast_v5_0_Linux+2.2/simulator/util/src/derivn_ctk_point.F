      integer function derivn_ctk_point(c1, c2, R)

c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Calculate the derivatives of the helix parameters at a new reference
c  point wrt parameters at the old reference point in a solenoidal B
c  field.
c
c  The derivative is calculated numerically.
c
c  c1       c track structure (read)
c           Track parameters at old reference point
c
c  c2       c track structure (read)
c           Track parameters at new reference point
c
c *R        DFLOAT array (write)
c           5x5 derivative matrix of d(c2) / d(c1)
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      implicit none

#include "ctrack_struct.inc"
#include "const.inc"

c     Externals
      integer  move_ctk_point
      DFLOAT     phi_small, phi_norm
      external move_ctk_point
      external phi_small, phi_norm

c     calling arguments
      record /ctrack_struct/ c1, c2
      DFLOAT R(5,5)

c     local variables
      record /ctrack_struct/ ci, cf
      DFLOAT dcu, dphi0, dda, dct, dz0, psave, psave1
      DFLOAT psave2, s3d
      integer status

      data dcu /0.001/
      data dphi0 /0.01/
      data dda /0.1/
      data dct /0.01/
      data dz0 /0.1/

      save dcu, dphi0, dda, dct, dz0
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     Save initial helix
      call ucopy(c1, ci, CTRACK_WORD)

      call vzero(R, 5*5*FLOAT_WORD)

c     Change each parameter in turn to calculate numerical derivative

      psave = ci.cu
      ci.cu = ci.cu + dcu
      status = move_ctk_point(ci, c2.xref, cf, s3d)
      if(status .ne. 0) goto 9999
      R(jccu,jccu)  = (cf.cu - c2.cu) / dcu
      R(jcphi,jccu) = phi_small(cf.phi0 - c2.phi0) / dcu
      R(jcda,jccu)  = (cf.da - c2.da) / dcu
      R(jcct,jccu)  = (cf.ct - c2.ct) / dcu
      R(jcz0,jccu)  = (cf.z0 - c2.z0) / dcu
      ci.cu = psave

      psave = ci.phi0
      psave1 = ci.u0
      psave2 = ci.v0
      ci.phi0 = phi_norm(ci.phi0 + dphi0)
      ci.u0 = cos(ci.phi0)
      ci.v0 = sin(ci.phi0)
      status = move_ctk_point(ci, c2.xref, cf, s3d)
      if(status .ne. 0) goto 9999
      R(jccu,jcphi)  = (cf.cu - c2.cu) / dphi0
      R(jcphi,jcphi) = phi_small(cf.phi0 - c2.phi0) / dphi0
      R(jcda,jcphi)  = (cf.da - c2.da) / dphi0
      R(jcct,jcphi)  = (cf.ct - c2.ct) / dphi0
      R(jcz0,jcphi)  = (cf.z0 - c2.z0) / dphi0
      ci.phi0 = psave
      ci.u0 = psave1
      ci.v0 = psave2

      psave = ci.da
      ci.da = ci.da + dda
      status = move_ctk_point(ci, c2.xref, cf, s3d)
      if(status .ne. 0) goto 9999
      R(jccu,jcda)  = (cf.cu - c2.cu) / dda
      R(jcphi,jcda) = phi_small(cf.phi0 - c2.phi0) / dda
      R(jcda,jcda)  = (cf.da - c2.da) / dda
      R(jcct,jcda)  = (cf.ct - c2.ct) / dda
      R(jcz0,jcda)  = (cf.z0 - c2.z0) / dda
      ci.da = psave

      psave = ci.ct
      ci.ct = ci.ct + dct
      status = move_ctk_point(ci, c2.xref, cf, s3d)
      if(status .ne. 0) goto 9999
      R(jccu,jcct)  = (cf.cu - c2.cu) / dct
      R(jcphi,jcct) = phi_small(cf.phi0 - c2.phi0) / dct
      R(jcda,jcct)  = (cf.da - c2.da) / dct
      R(jcct,jcct)  = (cf.ct - c2.ct) / dct
      R(jcz0,jcct)  = (cf.z0 - c2.z0) / dct
      ci.ct = psave

      psave = ci.z0
      ci.z0 = ci.z0 + dz0
      status = move_ctk_point(ci, c2.xref, cf, s3d)
      if(status .ne. 0) goto 9999
      R(jccu,jcz0)  = (cf.cu - c2.cu) / dz0
      R(jcphi,jcz0) = phi_small(cf.phi0 - c2.phi0) / dz0
      R(jcda,jcz0)  = (cf.da - c2.da) / dz0
      R(jcct,jcz0)  = (cf.ct - c2.ct) / dz0
      R(jcz0,jcz0)  = (cf.z0 - c2.z0) / dz0
      ci.z0 = psave

      derivn_ctk_point = 0
      return

c     Error return
9999  derivn_ctk_point = status
      return

      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:44  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:31:24  garren
c add rcs log line
c
