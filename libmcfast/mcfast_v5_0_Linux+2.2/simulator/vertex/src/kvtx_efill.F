      integer function kvtx_efill(it)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C     Computes the E array for the vertex fit.
C
C  IT      integer variable (read)
C          kine track number to add to vertex fit
C created 10/10/94 A. Boehnlein from P. Avery kn routines
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
      IMPLICIT NONE

#include "const.inc"
#include "track_kine.inc"
#include "kine_vtx_cnst.inc"

C     External declarations

c     calling arguments
      integer it

c     local variables
c  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      vtx_cnst.trk_cnst(it).e(1,1) = -vtx_cnst.trk_cnst(it).d(5,1)
      vtx_cnst.trk_cnst(it).e(2,1) = -vtx_cnst.trk_cnst(it).d(6,1)
      vtx_cnst.trk_cnst(it).e(3,1) =  0.
      vtx_cnst.trk_cnst(it).e(1,2) = -vtx_cnst.trk_cnst(it).d(5,2)
      vtx_cnst.trk_cnst(it).e(2,2) = -vtx_cnst.trk_cnst(it).d(6,2)
      vtx_cnst.trk_cnst(it).e(3,2) =  1.

      kvtx_efill = 0
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
