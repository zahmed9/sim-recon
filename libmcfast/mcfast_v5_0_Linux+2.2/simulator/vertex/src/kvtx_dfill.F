      integer function kvtx_dfill(it)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C   Fill some track variables for the vertex fit.
C
C  IT      integer variable (read)
C          Number of the track to be fit
C
C
C   Side effects
C     None
C
C   Externals called
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
#include "track_dx.inc"
#include "kine_vtx_cnst.inc"
#include "kine_bfld.inc"
C
C     Calling arguments
      INTEGER IT
C
C     Local variables
      DFLOAT sinmax
      DFLOAT aa, a1, a2, rho, r2d2, dlx, dly
      DFLOAT sininv, sqrtag
      DFLOAT temp,temp1,temp2
      DATA sinmax/0.99999/
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  Created 10/10/94 A. Boehnlein from P. Avery CLEO routines KWDMP + KWD001

C     AA = c_b * B * Q (B = mag. field, Q = charge)
      aa = c_b * kine_bfld.bmag * p1(it).q


      if( p1(it).pt.gt. 0.) then
        rho = aa / p1(it).pt
      else
        rho = aa * 1000.
      endif

      dlx = vtx_cnst.zv(1) - p1(it).x
      dly = vtx_cnst.zv(2) - p1(it).y

      a1 = -dlx*p1(it).py + dly*p1(it).px
      a2 =  dlx*p1(it).px + dly*p1(it).py
      r2d2 = dlx**2 + dly**2
      if(rho .ne. 0.) then
        temp = aa * a2 / p1(it).pt**2
        if(abs(temp) .gt. sinmax) goto 9999
        sininv = asin(temp)
        sqrtag = 1. / sqrt(1. - temp**2)
      else
        sininv = 0.
        sqrtag = 1.
      endif

C     Compute D and d1
      temp1 = p1(it).pz * sqrtag / p1(it).pt**2
      temp2 = a2 / p1(it).pt**2
      if(rho .ne. 0.) then
        vtx_cnst.trk_cnst(it).d1(1) = a1 - 0.5 * aa * r2d2
        vtx_cnst.trk_cnst(it).d1(2) = vtx_cnst.zv(3) - p1(it).z - 
     *                                p1(it).pz/aa * sininv
      else
        vtx_cnst.trk_cnst(it).d1(1) = a1
        vtx_cnst.trk_cnst(it).d1(2) = vtx_cnst.zv(3) - p1(it).z - 
     *                                p1(it).pz * temp2
      endif
      vtx_cnst.trk_cnst(it).d(1,1) =  dly
      vtx_cnst.trk_cnst(it).d(2,1) = -dlx
      vtx_cnst.trk_cnst(it).d(3,1) =  0.
      vtx_cnst.trk_cnst(it).d(4,1) =  0.
      vtx_cnst.trk_cnst(it).d(5,1) =  p1(it).py + aa * dlx
      vtx_cnst.trk_cnst(it).d(6,1) = -p1(it).px + aa * dly
      vtx_cnst.trk_cnst(it).d(7,1) =  0.
      vtx_cnst.trk_cnst(it).d(1,2) = -temp1 * (-2.*p1(it).px*temp2
     *                                         + dlx)
      vtx_cnst.trk_cnst(it).d(2,2) = -temp1 * (-2.*p1(it).py*temp2
     *                                         + dly)
      if(rho .ne. 0.) then
        vtx_cnst.trk_cnst(it).d(3,2) = -sininv / aa
      else
        vtx_cnst.trk_cnst(it).d(3,2) = -temp2
      endif
      vtx_cnst.trk_cnst(it).d(4,2) =  0.
      vtx_cnst.trk_cnst(it).d(5,2) = p1(it).px * temp1
      vtx_cnst.trk_cnst(it).d(6,2) = p1(it).py * temp1
      vtx_cnst.trk_cnst(it).d(7,2) = -1.
C     Normal return
      kvtx_dfill = 0
      return

c     error return
9999  kvtx_dfill = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:13  garren
c add rcs log line
c

