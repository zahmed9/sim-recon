      integer function kvtx_cov_update(ik)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Update the covariance matrix of an input track for a fixed
C    vertex fik.
C
C  IK      integer variable (read)
C          track_kine track ID
C
C   Side effects
C     None
C
C   Externals called
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  created 10/10/94 A. Boehnlein from P. Avery KN code
C
      implicit none
#include "const.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
C
C     Calling arguments
      integer ik
C
C     Local variables
      integer i, j
      DFLOAT vddvx(2,7)
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

C     Check for legal track and if trck has covariance matrix
      if(ik.le.0 .or. ik.gt.trk_num) goto 9999
      if(    trk_kine(ik).icov.lt.1
     *  .or. trk_kine(ik).status.ne.1) goto 9999

C     Compute VDDVX = VD * D * Vx0 = VD * DVX
      do 100 i=1,7
        vddvx(1,i) = vtx_cnst.trk_cnst(ik).vd(1,1)
     *             * vtx_cnst.trk_cnst(ik).dvx(1,i)
     *             + vtx_cnst.trk_cnst(ik).vd(2,1)
     *             * vtx_cnst.trk_cnst(ik).dvx(2,i)
        vddvx(2,i) = vtx_cnst.trk_cnst(ik).vd(1,2)
     *             * vtx_cnst.trk_cnst(ik).dvx(1,i)
     *             + vtx_cnst.trk_cnst(ik).vd(2,2)
     *             * vtx_cnst.trk_cnst(ik).dvx(2,i)
100   continue
      do 120 i=1,7
        do 110 j=1,i
          trk_kine(ik).cov(j,i) = trk_kine(ik).cov(j,i)
     *             - vtx_cnst.trk_cnst(ik).dvx(1,j)*vddvx(1,i)
     *             - vtx_cnst.trk_cnst(ik).dvx(2,j)*vddvx(2,i)     
          trk_kine(ik).cov(i,j) = trk_kine(ik).cov(j,i)
110     continue
120    continue


c     normal return
1000  kvtx_cov_update = 0
      return

c     error return
9999  kvtx_cov_update = 0
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.3  1998/03/19 02:55:19  mcbride
c allow icov = 2 tracks
c
c Revision 1.2  1997/04/04  20:32:12  garren
c add rcs log line
c
