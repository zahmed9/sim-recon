      integer function kvtx_vdfill(it)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Fill the VD and lam arrays for vertex fit
C
C  IT      integer variable (read)
C          Number of the track to be fit
C
C   Side effects
C     None
C
C   Externals called
C  Created 10/10/94 A. Boehnlein from P. Avery's KN code
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
#include "track_dx.inc"
#include "kine_vtx_cnst.inc"
#include "wtrack_struct.inc"
C
c     calling arguments
      integer it
c
c     local variables
      integer i,ifail
      DFLOAT a(2,2)
      record /wtrack_struct/ dif
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

c     compute vd = [d * vx0 * d(t) * Vz0 * E(t)] (inv)
      do 100 i=1,7
        vtx_cnst.trk_cnst(it).dvx(1,i) =
     *        vtx_cnst.trk_cnst(it).d(1,1)
     *      * p1c(it).cov(1,i)
     *      + vtx_cnst.trk_cnst(it).d(2,1)
     *      * p1c(it).cov(2,i)
     *      + vtx_cnst.trk_cnst(it).d(3,1)
     *      * p1c(it).cov(3,i)
     *      + vtx_cnst.trk_cnst(it).d(4,1)
     *      * p1c(it).cov(4,i)
     *      + vtx_cnst.trk_cnst(it).d(5,1)
     *      * p1c(it).cov(5,i)
     *      + vtx_cnst.trk_cnst(it).d(6,1)
     *      * p1c(it).cov(6,i)
     *      + vtx_cnst.trk_cnst(it).d(7,1)
     *      * p1c(it).cov(7,i)
        vtx_cnst.trk_cnst(it).dvx(2,i) =
     *        vtx_cnst.trk_cnst(it).d(1,2)
     *      * p1c(it).cov(1,i)
     *      + vtx_cnst.trk_cnst(it).d(2,2)
     *      * p1c(it).cov(2,i)
     *      + vtx_cnst.trk_cnst(it).d(3,2)
     *      * p1c(it).cov(3,i)
     *      + vtx_cnst.trk_cnst(it).d(4,2)
     *      * p1c(it).cov(4,i)
     *      + vtx_cnst.trk_cnst(it).d(5,2)
     *      * p1c(it).cov(5,i)
     *      + vtx_cnst.trk_cnst(it).d(6,2)
     *      * p1c(it).cov(6,i)
     *      + vtx_cnst.trk_cnst(it).d(7,2)
     *      * p1c(it).cov(7,i)
100   continue
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
      call ucopy(vtx_cnst.trk_cnst(it).vd, a, 2*2*float_word)
c      call dsynv2(a, 2, 2, ifail)
      call dsinv(2,a,2,ifail)
      call ucopy(a, vtx_cnst.trk_cnst(it).vd, 2*2*float_word)
       
      if(ifail.ne.0) goto 9999

c     calculate initial lagrange multipliers per track
c     lam0 = vd * (d*x0 + d1)
c     x0 = tr0wkn - trkwkn
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
      kvtx_vdfill = 0
      return

c     error return
9999  kvtx_vdfill = 1
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
