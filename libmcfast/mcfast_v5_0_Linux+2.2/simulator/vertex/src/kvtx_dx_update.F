      integer function kvtx_dx_update(it, ylam, lbase)
C
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C  Calculates the updated input tracks from a vertex fit for a track in the
C  W representation.
C
C  IT      integer variable (read)
C          trk_kine track number
C
C  YLAM    real array(read)
C          Lagrange multipliers
C
C  LBASE   logical variable (read)
C          TRUE  ==> correction is added to 0
C          FALSE ==> correction is added to to original value of DX
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
C created 10/10/94 A. Boehnlein from P. Avery KN code
C
      IMPLICIT NONE
#include "const.inc"
#include "track_kine.inc"
#include "track_dx.inc"
#include "kine_vtx_cnst.inc"

C     Calling arguments
      integer it
      DFLOAT ylam(2)
      logical lbase
C  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

      if(lbase) then
          trk_dx(it).px = -vtx_cnst.trk_cnst(it).dvx(1,1)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,1)*ylam(2)
     
          trk_dx(it).py = -vtx_cnst.trk_cnst(it).dvx(1,2)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,2)*ylam(2)
     
          trk_dx(it).pz = -vtx_cnst.trk_cnst(it).dvx(1,3)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,3)*ylam(2)
     
          trk_dx(it).e  = -vtx_cnst.trk_cnst(it).dvx(1,4)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,4)*ylam(2)
     
          trk_dx(it).x  = -vtx_cnst.trk_cnst(it).dvx(1,5)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,5)*ylam(2)
     
          trk_dx(it).y  = -vtx_cnst.trk_cnst(it).dvx(1,6)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,6)*ylam(2)
     
          trk_dx(it).z  = -vtx_cnst.trk_cnst(it).dvx(1,7)*ylam(1)
     *                     - vtx_cnst.trk_cnst(it).dvx(2,7)*ylam(2)
       else
          trk_dx(it).px = trk_dx(it).px
     *                    - vtx_cnst.trk_cnst(it).dvx(1,1)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,1)*ylam(2)
     
          trk_dx(it).py = trk_dx(it).py
     *                    - vtx_cnst.trk_cnst(it).dvx(1,2)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,2)*ylam(2)
     
          trk_dx(it).pz = trk_dx(it).pz
     *                    - vtx_cnst.trk_cnst(it).dvx(1,3)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,3)*ylam(2)
     
          trk_dx(it).e  = trk_dx(it).e
     *                    - vtx_cnst.trk_cnst(it).dvx(1,4)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,4)*ylam(2)
     
          trk_dx(it).x  = trk_dx(it).x
     *                    - vtx_cnst.trk_cnst(it).dvx(1,5)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,5)*ylam(2)
     
          trk_dx(it).y  = trk_dx(it).y
     *                    - vtx_cnst.trk_cnst(it).dvx(1,6)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,6)*ylam(2)
     
          trk_dx(it).z  = trk_dx(it).z
     *                    - vtx_cnst.trk_cnst(it).dvx(1,7)*ylam(1)
     *                    - vtx_cnst.trk_cnst(it).dvx(2,7)*ylam(2)
      endif

      kvtx_dx_update = 0
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
