      integer function kvtx_vdfill2(it, vz0)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Calculates VD, lam0 arrays
C
C  IT      integer variable (read)
C          KN track number to add to vertex fit
C
C  VZ0     real array (read)
C          3 x 3 covariance matrix of Z0
C
C *LERROR  logical variable (read)
C          TRUE if error
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
c  created 11/21/94 A. Boehnlein from P. Avery CLEO routine KWVD02
c  modified 2/06/96 L. Garren    remove DFLOAT dif

      implicit none
#include "const.inc"
#include "track_kine.inc"
#include "track_dx.inc"
#include "kine_vtx_cnst.inc"
#include "wtrack_struct.inc"
C     External declarations

C     Calling arguments
      integer it
      DFLOAT vz0(3,3)

C     Local variables
      integer i, ifail
      DFLOAT vtmp(3,3), evz(3,3)
      record /wtrack_struct/ dif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Compute VD = [D * Vx0 * D(t) + E * Vz0 * E(t)] (inv)
      DO 100 I=1,7
        vtx_cnst.trk_cnst(it).dvx(1,i) =
     *        vtx_cnst.trk_cnst(it).d(1,1)
     *      * trk_kine(it).cov(1,i)
     *      + vtx_cnst.trk_cnst(it).d(2,1)
     *      * trk_kine(it).cov(2,i)
     *      + vtx_cnst.trk_cnst(it).d(3,1)
     *      * trk_kine(it).cov(3,i)
     *      + vtx_cnst.trk_cnst(it).d(4,1)
     *      * trk_kine(it).cov(4,i)
     *      + vtx_cnst.trk_cnst(it).d(5,1)
     *      * trk_kine(it).cov(5,i)
     *      + vtx_cnst.trk_cnst(it).d(6,1)
     *      * trk_kine(it).cov(6,i)
     *      + vtx_cnst.trk_cnst(it).d(7,1)
     *      * trk_kine(it).cov(7,i)
        vtx_cnst.trk_cnst(it).dvx(2,i) =
     *        vtx_cnst.trk_cnst(it).d(1,2)
     *      * trk_kine(it).cov(1,i)
     *      + vtx_cnst.trk_cnst(it).d(2,2)
     *      * trk_kine(it).cov(2,i)
     *      + vtx_cnst.trk_cnst(it).d(3,2)
     *      * trk_kine(it).cov(3,i)
     *      + vtx_cnst.trk_cnst(it).d(4,2)
     *      * trk_kine(it).cov(4,i)
     *      + vtx_cnst.trk_cnst(it).d(5,2)
     *      * trk_kine(it).cov(5,i)
     *      + vtx_cnst.trk_cnst(it).d(6,2)
     *      * trk_kine(it).cov(6,i)
     *      + vtx_cnst.trk_cnst(it).d(7,2)
     *      * trk_kine(it).cov(7,i)
100   CONTINUE
      vtx_cnst.trk_cnst(it).vd(1,1) = 
     *             vtx_cnst.trk_cnst(it).d(1,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,1)
     *           + vtx_cnst.trk_cnst(it).d(2,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,2)
     *           + vtx_cnst.trk_cnst(it).d(3,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,3)
     *           + vtx_cnst.trk_cnst(it).d(4,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,4)
     *           + vtx_cnst.trk_cnst(it).d(5,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,5)
     *           + vtx_cnst.trk_cnst(it).d(6,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,6)
     *           + vtx_cnst.trk_cnst(it).d(7,1)
     *           * vtx_cnst.trk_cnst(it).dvx(1,7)
     
      vtx_cnst.trk_cnst(it).vd(2,1) = 
     *             vtx_cnst.trk_cnst(it).d(1,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,1)
     *           + vtx_cnst.trk_cnst(it).d(2,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,2)
     *           + vtx_cnst.trk_cnst(it).d(3,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,3)
     *           + vtx_cnst.trk_cnst(it).d(4,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,4)
     *           + vtx_cnst.trk_cnst(it).d(5,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,5)
     *           + vtx_cnst.trk_cnst(it).d(6,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,6)
     *           + vtx_cnst.trk_cnst(it).d(7,2)
     *           * vtx_cnst.trk_cnst(it).dvx(1,7)
     
      vtx_cnst.trk_cnst(it).vd(1,2) = vtx_cnst.trk_cnst(it).vd(2,1)

      vtx_cnst.trk_cnst(it).vd(2,2) = 
     *             vtx_cnst.trk_cnst(it).d(1,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,1)
     *           + vtx_cnst.trk_cnst(it).d(2,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,2)
     *           + vtx_cnst.trk_cnst(it).d(3,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,3)
     *           + vtx_cnst.trk_cnst(it).d(4,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,4)
     *           + vtx_cnst.trk_cnst(it).d(5,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,5)
     *           + vtx_cnst.trk_cnst(it).d(6,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,6)
     *           + vtx_cnst.trk_cnst(it).d(7,2)
     *           * vtx_cnst.trk_cnst(it).dvx(2,7)
      do 110 i=1,3
        evz(1,i) = vtx_cnst.trk_cnst(it).e(1,1)*vz0(1,i)
     *           + vtx_cnst.trk_cnst(it).e(2,1)*vz0(2,i)
     *           + vtx_cnst.trk_cnst(it).e(3,1)*vz0(3,i)
        evz(2,i) = vtx_cnst.trk_cnst(it).e(1,2)*vz0(1,i)
     *           + vtx_cnst.trk_cnst(it).e(2,2)*vz0(2,i)
     *           + vtx_cnst.trk_cnst(it).e(3,2)*vz0(3,i)
110   continue
      vtmp(1,1) = vtx_cnst.trk_cnst(it).e(1,1)*evz(1,1)
     *          + vtx_cnst.trk_cnst(it).e(2,1)*evz(1,2)
     *          + vtx_cnst.trk_cnst(it).e(3,1)*evz(1,3)
      vtmp(2,1) = vtx_cnst.trk_cnst(it).e(1,2)*evz(1,1)
     *          + vtx_cnst.trk_cnst(it).e(2,2)*evz(1,2)
     *          + vtx_cnst.trk_cnst(it).e(3,2)*evz(1,3)
      vtmp(1,2) = vtmp(2,1)
      vtmp(2,2) = vtx_cnst.trk_cnst(it).e(1,2)*evz(2,1)
     *          + vtx_cnst.trk_cnst(it).e(2,2)*evz(2,2)
     *          + vtx_cnst.trk_cnst(it).e(3,2)*evz(2,3)
      vtx_cnst.trk_cnst(it).vd(1,1) =
     *          vtx_cnst.trk_cnst(it).vd(1,1) + vtmp(1,1)
      vtx_cnst.trk_cnst(it).vd(2,1) = 
     *          vtx_cnst.trk_cnst(it).vd(2,1) + vtmp(2,1)
      vtx_cnst.trk_cnst(it).vd(1,2) = 
     *          vtx_cnst.trk_cnst(it).vd(2,1)
      vtx_cnst.trk_cnst(it).vd(2,2) = 
     *          vtx_cnst.trk_cnst(it).vd(2,2) + vtmp(2,2)
      call dsynv2(vtx_cnst.trk_cnst(it).vd(1,1), 2, 2, ifail)
      if(ifail.ne.0) goto 9999

C     Calculate initial Lagrange multipliers per track
C     lam0 = VD * (D*x0 + d1)
C     x0 = TR0WKN - TRKWKN
      dif.px = p0(it).px - p1(it).px
      dif.py = p0(it).py - p1(it).py
      dif.pz = p0(it).pz - p1(it).pz
      dif.e  = p0(it).e  - p1(it).e
      dif.x  = p0(it).x  - p1(it).x
      dif.y  = p0(it).y  - p1(it).y
      dif.z  = p0(it).z  - p1(it).z
        
      vtx_cnst.trk_cnst(it).d1(1) = vtx_cnst.trk_cnst(it).d1(1)
     *         + vtx_cnst.trk_cnst(it).d(1,1)*dif.px
     *         + vtx_cnst.trk_cnst(it).d(2,1)*dif.py
     *         + vtx_cnst.trk_cnst(it).d(3,1)*dif.pz
     *         + vtx_cnst.trk_cnst(it).d(4,1)*dif.e
     *         + vtx_cnst.trk_cnst(it).d(5,1)*dif.x
     *         + vtx_cnst.trk_cnst(it).d(6,1)*dif.y
     *         + vtx_cnst.trk_cnst(it).d(7,1)*dif.z
      vtx_cnst.trk_cnst(it).d1(2) = vtx_cnst.trk_cnst(it).d1(2)
     *         + vtx_cnst.trk_cnst(it).d(1,2)*dif.px
     *         + vtx_cnst.trk_cnst(it).d(2,2)*dif.py
     *         + vtx_cnst.trk_cnst(it).d(3,2)*dif.pz
     *         + vtx_cnst.trk_cnst(it).d(4,2)*dif.e
     *         + vtx_cnst.trk_cnst(it).d(5,2)*dif.x
     *         + vtx_cnst.trk_cnst(it).d(6,2)*dif.y
     *         + vtx_cnst.trk_cnst(it).d(7,2)*dif.z
     
      vtx_cnst.trk_cnst(it).lam0(1)
     *           = vtx_cnst.trk_cnst(it).vd(1,1)
     *           * vtx_cnst.trk_cnst(it).d1(1)
     *           + vtx_cnst.trk_cnst(it).vd(2,1)
     *           * vtx_cnst.trk_cnst(it).d1(2)

      vtx_cnst.trk_cnst(it).lam0(2)
     *           = vtx_cnst.trk_cnst(it).vd(2,1)
     *           * vtx_cnst.trk_cnst(it).d1(1)
     *           + vtx_cnst.trk_cnst(it).vd(2,2)
     *           * vtx_cnst.trk_cnst(it).d1(2)
      vtx_cnst.trk_cnst(it).lam(1) = vtx_cnst.trk_cnst(it).lam0(1)
      vtx_cnst.trk_cnst(it).lam(2) = vtx_cnst.trk_cnst(it).lam0(2)

c     normal return
      kvtx_vdfill2 = 0
      return

C     Error return
9999  kvtx_vdfill2 = 1
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.3  1997/04/04 20:32:16  garren
c add rcs log line
c
