      integer function kvtx_evefill(it)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C    Fill the E(t)*VD*E and E(t)*lam0 arrays
C
C  it      integer variable (read)
C          Number of the track to be fit
C
C   Created 10/10/94 A. Boehnlein from P. Avery KN routines
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C
      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"
C
c     calling arguments
      integer it
c
c     local variables
      integer i
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      DO 100 I=1,3
        vtx_cnst.trk_cnst(it).vde(1,i) = 
     *                vtx_cnst.trk_cnst(it).vd(1,1)
     *              * vtx_cnst.trk_cnst(it).e(i,1)
     *              + vtx_cnst.trk_cnst(it).vd(2,1)
     *              * vtx_cnst.trk_cnst(it).e(i,2)
     
        vtx_cnst.trk_cnst(it).vde(2,i) = 
     *                vtx_cnst.trk_cnst(it).vd(2,1)
     *              * vtx_cnst.trk_cnst(it).e(i,1)
     *              + vtx_cnst.trk_cnst(it).vd(2,2)
     *              * vtx_cnst.trk_cnst(it).e(i,2)
100   continue

      do 200 i=1,3
        vtx_cnst.trk_cnst(it).eve(i,1) = vtx_cnst.trk_cnst(it).vde(1,i)
     *           * vtx_cnst.trk_cnst(it).e(1,1)
     *           + vtx_cnst.trk_cnst(it).vde(2,i)
     *           * vtx_cnst.trk_cnst(it).e(1,2)
     
        vtx_cnst.trk_cnst(it).eve(i,2) = vtx_cnst.trk_cnst(it).vde(1,i)
     *           * vtx_cnst.trk_cnst(it).e(2,1)
     *           + vtx_cnst.trk_cnst(it).vde(2,i)
     *           * vtx_cnst.trk_cnst(it).e(2,2)
     
        vtx_cnst.trk_cnst(it).eve(i,3) = vtx_cnst.trk_cnst(it).vde(1,i)
     *           * vtx_cnst.trk_cnst(it).e(3,1)
     *           + vtx_cnst.trk_cnst(it).vde(2,i)
     *           * vtx_cnst.trk_cnst(it).e(3,2)
     
        vtx_cnst.trk_cnst(it).elam(i)  = vtx_cnst.trk_cnst(it).e(i,1)
     *           * vtx_cnst.trk_cnst(it).lam0(1)
     *           + vtx_cnst.trk_cnst(it).e(i,2)
     *           * vtx_cnst.trk_cnst(it).lam0(2)
200   continue

      kvtx_evefill = 0
      return
      end

c $Id$
c $Log$
c Revision 1.1  2000/06/19 19:59:48  eugenio
c Initial revision
c
c Revision 1.2  1997/04/04 20:32:14  garren
c add rcs log line
c
